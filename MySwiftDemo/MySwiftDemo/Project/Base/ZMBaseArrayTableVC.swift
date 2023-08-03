//
//  ZMBaseArrayTableViewController.swift
//  GrainTrade
//
//  Created by milk on 2023/3/27.
//

import UIKit
import Alamofire

typealias HTTPMethodNoImport = HTTPMethod


class ZMBaseArrayTableVC<T: JsonModelProtocol>:ZMBaseTableVC {
    lazy var mainArray: [T] = {
        return [T]()
    }()
    private(set) var pageIndex: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //[列表页一般要开启的
    override func enableEmptyPlaceHolder() -> Bool {
        true
    }
    override func enableHeaderRefresh() -> Bool {
        true
    }
    override func enableFooterLoadMore() -> Bool {
        true
    }
    /// graphql page 参数信息自己处理
    func needPageParamAppend() -> Bool {
        true
    }
    //]
    
    /// 一个项目多种page 起始页标记(粮食0 商城1)
    func firstPageDefault() -> Int {
        0
    }
    func methodRequest() -> HTTPMethodNoImport {
        return .get
    }
    // MARK: Need Override 列表接口的地址
    func pathUrl() -> String? {
        return nil
    }
    // MARK: Need Override json解析路径
    func pathJsonDeserialize() -> String? {
        return nil
    }
    // MARK: Need Override 列表接口的请求参数，不需要包含page字段
    func apiParams() -> [String: Any]? {
        return nil//[String: Any]()
    }
    
    /// 子类调用的首页刷新方法
    @objc override final func headerRefresh() {
        pageIndex = firstPageDefault()
        // 在这里改变数据源 列表处于滑动状态调用cellForRow 会crash 所以在请求导数据后再处理数据 比较好
        //self.mainArray.removeAll()
        executeRequireList()
    }
    
    ///子类一般不需要调用 自动触发
    override final func footerLoadMore() {
        pageIndex += 1
        executeRequireList()
    }
    
    private func isFirstPage() -> Bool {
        return pageIndex == firstPageDefault()
    }
    /// 得到网络数据后伴随表刷新的其他刷新
    func reloadOtherUIAfterDataReady() {
        
    }
    //正式执行请求列表接口
    func executeRequireList() {
        
        var params = apiParams() ?? [String:Any]()
        if needPageParamAppend() {
            params["Page"] = String(self.pageIndex)
            params["Limit"] = String(self.onePageCount)
        }
       
        HttpManager.shared.request(methodRequest(),path: pathUrl(), params: params) {[weak self] result in
            
            //如果你不写上面的[weak self]。会出现：pop后vc第一时间不deinit，一定要这里的请求结束后且走完success里的所有代码后，再deinit
            guard let self = self else { return }
            let datas = [T].deserialize(from: result as? String, designatedPath: self.pathJsonDeserialize()) as? [T]
            HUD.hide()
            self.hideLoading()
            self.endHeaderRefreshing()
            self.endFooterRefreshing()
            self.hiddenFooterRefreshing(false)
            //清空数据
            if self.isFirstPage() {
                self.mainArray.removeAll()
            }
            //添加新数据
            if let datas = datas,datas.isEmpty == false {
                self.mainArray.append(contentsOf: datas)
            }
            // 本次数据小于请求数据 判定没有数据了
            if datas == nil || datas?.count ?? 0 < self.onePageCount {
                self.endFooterRefreshing(noMoreData: true)
            }
            //没有数据
            if self.isFirstPage() && self.mainArray.isEmpty {
                self.hiddenFooterRefreshing(true)
            }
            //列表切换 回滚顶部
            if self.isFirstPage() && self.mainArray.isEmpty == false && self.tableView.contentOffset.y > 0 {
                printLog("当前off=\(self.tableView.contentOffset.y)")
                self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            //刷新UI
            self.tableView.reloadData()
            self.reloadOtherUIAfterDataReady()
        } failure: {[weak self] errorMessage in
            
            guard let self = self else { return }
            HUD.hide()
            self.hideLoading()
            self.endHeaderRefreshing()
            self.endFooterRefreshing()
            self.hiddenFooterRefreshing(true)
            //刷新UI
            self.tableView.reloadData()
            self.reloadOtherUIAfterDataReady()
            //网络请求失败，服务器关闭或者json解析失败
            if (self.isFirstPage()) {
                //                    self.needShowEmptyView(show: self.mainArray.isEmpty, emptyImage: nil, emptyTitle: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.mainArray.count
    }
}

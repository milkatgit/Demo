//
//  ShopOrderListVC.swift
//  GrainTrade
//
//  Created by milk on 2023/1/15.
//

import UIKit

class ZMBaseSegmentVC: ZMBaseVC,JXSegmentedListContainerViewDataSource,JXSegmentedViewDelegate {
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var listContainerView: JXSegmentedListContainerView!
    var defaultIndex = 0
    override func titleForNav() -> String? {
        "override"
    }
    
    func segmentTitles() -> [String] {
        return ["override"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1、初始化JXSegmentedView
        segmentedView = JXSegmentedView()
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = segmentTitles()
        segmentedDataSource.titleNormalFont = UIFont.Bold.font_15
        segmentedDataSource.titleSelectedFont = UIFont.Bold.font_17
        segmentedDataSource.titleNormalColor = UIColor.GT.gray_3
        segmentedDataSource.titleSelectedColor = UIColor.GT.app
        segmentedDataSource.itemWidth = kScreenWidth / CGFloat(segmentedDataSource.titles.count)
        
        segmentedView.dataSource = segmentedDataSource
        segmentedDataSource.itemSpacing = 0
        segmentedView.contentEdgeInsetLeft = 0
        segmentedView.contentEdgeInsetRight = 0
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.GT.app
//        segmentedView.indicators = [indicator]
        //4、配置JXSegmentedView的属性
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        //5、初始化JXSegmentedListContainerView
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.equalTo(segmentedView)
            make.bottom.equalToSuperview().offset(-kTabbarHeight-kSafeBottom)
        }
        
        //6、将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.listContainer = listContainerView
//        listContainerView.scrollView.isScrollEnabled = false
        // Do any additional setup after loading the view.
        segmentedView.defaultSelectedIndex = defaultIndex
        listContainerView.defaultSelectedIndex = defaultIndex

    }

    //MARK: - delegate
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        printLog("must override")
        return UIViewController() as! JXSegmentedListContainerViewListDelegate
    }
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {

    }

//    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
//        let vc = ShopOrderListChildVCNew()
//        vc.type = index
//        if index == defaultIndex {
//            vc.showLoading(1)
//            vc.headerRefresh()
//        }
//        return vc
//    }
//    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//        if let vc = listContainerView.validListDict[index] as? ShopOrderListChildVCNew ,listContainerView.willDisappearIndex != index {
//            vc.showLoading(1)
//            vc.headerRefresh()
//        }
//    }
}


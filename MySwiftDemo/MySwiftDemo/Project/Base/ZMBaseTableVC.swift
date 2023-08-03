//
//  ZMBaseTableViewController.swift
//  GrainTrade
//
//  Created by milk on 2023/3/27.
//

import UIKit
import MJRefresh

class ZMBaseTableVC: ZMBaseVC,UITableViewDelegate,UITableViewDataSource {
    private var isTest = false
    /// 一页请求数据量默认20
    final var onePageCount = kRequestVolumeOnePage
    private(set) var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
//        addLoadingViewTo(view: self.tableView)
        bringLoadingViewToFront()
    }
    private func initTableView() {
        tableView = UITableView(frame: view.frame, style: tableViewStyle())
        tableView.delegate = self
        tableView.dataSource = self
        if enableEmptyPlaceHolder() {
            tableView.emptyDataSetDelegate = self
            tableView.emptyDataSetSource = self
        }
        tableView.separatorStyle = tableViewSeparatorStyle()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        tableView.estimatedRowHeight = tableViewEstimatedRowHeight()
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.01))
        /// mj_footer(group类型的tableview) 上面空白20px 找了半天?
        tableView.tableFooterView = v// UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            let top = ifHaveCustomNav() ? kNavBarHeight : 0
            make.top.equalTo(top)
            make.bottom.equalToSuperview()
        }
        if enableFooterLoadMore() {
            let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerLoadMore))
            tableView.mj_footer = footer
        }
        if (enableHeaderRefresh()) {
            let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
            //隐藏mj下拉刷新的时间和状态
            header.lastUpdatedTimeLabel?.isHidden = true;
            header.stateLabel?.isHidden = true;
            header.isAutomaticallyChangeAlpha = true;
            tableView.mj_header = header;
            
            //先设置为没有下一页
            tableView.mj_footer?.isHidden = true;
        }
    }
    
   
    //open - 结束下拉刷新，子类主动调用；这个方法经常使用
    func endHeaderRefreshing(){
        tableView.mj_header?.endRefreshing()
    }
    func hiddenFooterRefreshing(_ hidden:Bool) {
        tableView.mj_footer?.isHidden = hidden
    }
    
    //open - 结束底部翻页，子类主动调用；这个方法经常使用
    func endFooterRefreshing(noMoreData:Bool = false){
        if noMoreData {
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        }else {
            tableView.mj_footer?.endRefreshing()
        }
    }
    
    //open - 主动触发下拉刷新
    func beginFooterRefreshing(){
        tableView.mj_footer?.beginRefreshing()
    }
    
    //open - 主动触发底部翻页
    func beginHeaderRefreshing(){
        tableView.mj_header?.beginRefreshing()
    }
    
    //MARK: - public override methods
    func tableViewStyle() -> UITableView.Style { .grouped }
    func tableViewSeparatorStyle() -> UITableViewCell.SeparatorStyle { .singleLine }
    func tableViewEstimatedRowHeight() -> CGFloat { 200 }
    
    /// nil->不是圆角 false->不单独设置  true->单独设置每个cell都是圆角
    func enableCellCorner() -> Bool? { nil }
    /// 绘制圆角后cell中间的间隔(建议不超过10(如果太大需要去处理对应cell的上下margin))
    func enableCellCornerSectionSpace() -> CGFloat { 4 }
    func enableCellCornerCornerRadius() -> CGFloat { 10 }
    func enableEmptyPlaceHolder() -> Bool { false }
    func enableHeaderRefresh() -> Bool { false }
    func enableFooterLoadMore() -> Bool { false }
    @objc func headerRefresh() {
        printLog("\(self)需要实现该方法")
    }
    @objc func footerLoadMore() {
        printLog("\(self)需要实现该方法")
    }
    
    //MARK: - delegate & dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isTest ? 1 : 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isTest {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "test"
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.style == .plain ? 0 : 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.style == .plain ? 0 : 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let needSetAlone = enableCellCorner() {
            self.setCornerRadiusForSectionCell(cell: cell, indexPath: indexPath, tableView: tableView, needSetAlone: needSetAlone, cellY: enableCellCornerSectionSpace())
        }
    }

    /// 设置cell圆角
    /// - Parameters:
    ///   - cell: cell
    ///   - indexPath: indexPath
    ///   - tableView: tableView
    ///   - needSetAlone: 是否需要单独设置每个cell都是圆角. 默认按section为单位整体设置, 如果一个section只有一个cell则全部设置圆角
    public func setCornerRadiusForSectionCell(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView, needSetAlone: Bool, cellY: CGFloat)
    {
        //圆角半径
        let cornerRadius:CGFloat = enableCellCornerCornerRadius()

        //下面为设置圆角操作（通过遮罩实现）
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil
        //cell.contentView.backgroundColor = .white
      
        if needSetAlone {
            let bezierPath = UIBezierPath(roundedRect:
                                            cell.bounds.insetBy(dx: 0.0, dy: cellY),
                                          cornerRadius: cornerRadius)
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        } else {
            //当前分区有多行数据时
            if sectionCount > 1 {
                switch indexPath.row {
                    //如果是第一行,左上、右上角为圆角
                case 0:
                    var bounds = cell.bounds
                    bounds.origin.y += cellY / 2// 1.0  //这样每一组首行顶部分割线不显示
                    let bezierPath = UIBezierPath(roundedRect: bounds,
                                                  byRoundingCorners: [.topLeft,.topRight],
                                                  cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                    shapeLayer.path = bezierPath.cgPath
                    cell.layer.mask = shapeLayer
                    //如果是最后一行,左下、右下角为圆角
                case sectionCount - 1:
                    var bounds = cell.bounds
                    bounds.size.height -= cellY / 2// 1.0  //这样每一组尾行底部分割线不显示
                    let bezierPath = UIBezierPath(roundedRect: bounds,
                                                  byRoundingCorners: [.bottomLeft,.bottomRight],
                                                  cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                    shapeLayer.path = bezierPath.cgPath
                    cell.layer.mask = shapeLayer
                default:
                    break
                }
            }
            //当前分区只有一行行数据时
            else {
                //四个角都为圆角（同样设置偏移隐藏首、尾分隔线）
                let bezierPath = UIBezierPath(roundedRect:
                                                cell.bounds.insetBy(dx: 0.0, dy: cellY),
                                              cornerRadius: cornerRadius)
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            }
        }
    }
}
extension ZMBaseTableVC : DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let image = UIImage(named: "tips_empty_nothing")
        return image
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "没有内容哦"
        let att = NSMutableAttributedString(string: text)
        att.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.GT.a8], range: NSMakeRange(0, text.count))
        return att
    }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
//        let text = "what is this"
//        let att = NSMutableAttributedString(string: text)
//        att.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.GT.gray_3], range: NSMakeRange(0, text.count))
//
//        return att
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
//        let text = "click"
//        let att = NSMutableAttributedString(string: text)
//        att.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.GT.gray_3], range: NSMakeRange(0, text.count))
//
//        return att
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        let h1 = image(forEmptyDataSet: scrollView)?.size.height ?? 0
        let h = scrollView.height
//        printLog("himage=\(h1)h=\(h)")
//        return -100
        return -h/2 + h1 //+ 20
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        printLog("im tap")
    }
//    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
//        printLog("tap button-\(button.currentTitle ?? "")")
//    }
}

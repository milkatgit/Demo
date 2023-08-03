////
////  ShopTestVC.swift
////  GrainTrade
////
////  Created by milk on 2023/1/9.
////
//
//import UIKit
//import HandyJSON
//import SnapKit
//
//class ShopTestVC: BaseTableVC {
//
//    var datas = [ShopWXModel]()
//    var module = ShopTestModule()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//        loadData()
//    }
//    override func setupUI() {
//        setNavTitle("朋友圈")
//        setTableSections([module])
//    }
//    override func loadData() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+0) {
//            self.datas = WXCellConfig.shared.createDatas()
//            self.module.setData(self.datas) { index, tbs in
//
//            } dataForCellHandler: {[unowned self] cell, row, tbs in
//                let m = self.datas[row]
//                if let cell = cell as? ShopWXCell {
//                    cell.bindModel(m)
//                    cell.callExtend = {[unowned self] in
//                        let indexPath = NSIndexPath(row: row, section: 0) as IndexPath
//                        UIView.performWithoutAnimation {
//                            self.tableView.reloadRows(at: [indexPath], with: .none)
//                        }
//                    }
//                }
//            }
//            self.reloadTableData()
//        }
//    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let m = self.datas[indexPath.row]
//        return m.cellHeight
//    }
//
//}
//
//class ShopTestModule: TableSectionProvider {
//    var cellType: UITableViewCell.Type = ShopWXCell.self
//}
//
//
//class ShopWXCell:BaseCell {
//    /// debug
//    var isShowBgColor = false
//    var cellInfo = WXCellConfig.shared
//    var callExtend : (()->Void)?
//    var callLikeShowHidden : (()->Void)?
//    
//    
//    var headerV = UIButton()
//    var nameL = UIButton()
//    var mainL = UILabel()
//    var extendBtn = UIButton()
//    var extendBgView = UIView()
//    var timeL = UILabel()
//    var rightBtn = UIButton()
//    var rightBgView = UIView()
//    
//    var likeView = WXLikeView()
//    
//    
//    /// 全文view隐藏显示
//    var heightContrainst : Constraint?
//    /// mainL高度变化
//    var heightMainLContrainst : Constraint?
//
//    var model : ShopWXModel?
//    
//    override func setUI() {
//        contentView.addSubview(headerV)
//        headerV.layer.masksToBounds = true
//        headerV.layer.cornerRadius = 5
//        headerV.backgroundColor = UIColor.green.withAlphaComponent(0.1)
//        
//        contentView.addSubview(nameL)
//        nameL.setTitleColor(UIColor.GT.blue, for: .normal)
//        nameL.titleLabel?.font = UIFont.Bold.font_15
//        let image = UIImage.imageWithColor(UIColor.GT.gray_6)
//        nameL.setBackgroundImage(image, for: .highlighted)
//        
//        
//        contentView.addSubview(mainL)
//        mainL.textColor = UIColor.black
//        mainL.font = UIFont.Normal.font_content_14
//        mainL.numberOfLines = 0
//        
//        contentView.addSubview(extendBgView)
//        extendBgView.addSubview(extendBtn)
//        extendBtn.setTitleColor(UIColor.GT.blue, for: .normal)
//        extendBtn.titleLabel?.font = UIFont.Normal.font_content_14
//        extendBtn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
//        extendBtn.addTarget(self, action: #selector(btndownAction(_:)), for: .touchDown)
//        extendBtn.addTarget(self, action: #selector(btndragAction(_:)), for: .touchDragExit)
//
//        contentView.addSubview(timeL)
//        timeL.textColor = UIColor.GT.gray_6
//        timeL.font = UIFont.Normal.font_time_9
//        
//        rightBgView = UIView()
//        rightBgView.backgroundColor = .white
//        contentView.addSubview(rightBgView)
//        
//        contentView.addSubview(rightBtn)
//        rightBtn.setTitle("..", for: .normal)
//        rightBtn.layer.cornerRadius = 2
//        rightBtn.layer.masksToBounds = true
//        rightBtn.backgroundColor = UIColor.GT.bg_e
//        rightBtn.setTitleColor(UIColor.GT.blue, for: .normal)
//        rightBtn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
//        
//        contentView.addSubview(likeView)
//        contentView.insertSubview(likeView, belowSubview: rightBgView)
//        
//        headerV.snp.makeConstraints { make in
//            make.left.top.equalTo(kMargin)
//            make.width.height.equalTo(cellInfo.headerH)
//        }
//        nameL.snp.makeConstraints { make in
//            make.left.equalTo(headerV.snp.right).offset(kMargin_10)
//            make.top.equalTo(headerV).offset(kMargin_5)
//            make.height.equalTo(cellInfo.nameLHeight)
//        }
//        mainL.snp.makeConstraints { make in
//            make.left.equalTo(nameL)
//            make.top.equalTo(nameL.snp.bottom).offset(kMargin_10)
//            make.right.equalTo(-kMargin)
//            self.heightMainLContrainst = make.height.equalTo(0).constraint
//        }
//        extendBgView.snp.makeConstraints { make in
//            make.left.equalTo(mainL)
//            make.top.equalTo(mainL.snp.bottom).offset(kMargin_10)
//            make.right.equalTo(-kMargin)
//            self.heightContrainst = make.height.equalTo(cellInfo.extendBtnSuperViewHeight).constraint
//        }
//        extendBtn.snp.makeConstraints { make in
//            make.left.top.equalToSuperview()
//            make.height.equalTo(cellInfo.extendBtnHeight)
//        }
//        timeL.snp.makeConstraints { make in
//            make.left.equalTo(mainL)
//            make.top.equalTo(extendBgView.snp.bottom)
//            make.height.equalTo(cellInfo.timeLHeight)
////            make.bottom.equalTo(-kMargin)
//        }
//        
//        rightBtn.snp.makeConstraints { make in
//            make.right.equalTo(-kMargin)
//            make.centerY.equalTo(timeL)
//            make.width.equalTo(25)
//            make.height.equalTo(15)
//        }
//        rightBgView.snp.makeConstraints { make in
//            make.right.bottom.equalToSuperview()
//            make.height.equalTo(likeView.selfSize.height + 10)
//            make.left.equalTo(rightBtn).offset(-kMargin)
//        }
//        likeView.snp.makeConstraints { make in
//            make.left.equalTo(rightBgView)
//            make.centerY.equalTo(rightBtn)
//            make.size.equalTo(self.likeView.selfSize)
//        }
//        
//        if isShowBgColor {
//            let color = UIColor.red.withAlphaComponent(0.2)
//            nameL.backgroundColor = color
//            mainL.backgroundColor = color
//            extendBgView.backgroundColor = color
//            timeL.backgroundColor = color
//        }
//    }
//    @objc func rightAction(_ btn:UIButton) {
//        self.callLikeShowHidden?()
//        self.showLikeView()
//        
//    }
//    func showLikeView() {
//        UIView.animate(withDuration: 0.25) {
//            self.likeView.snp.updateConstraints { make in
//                make.left.equalTo(self.rightBgView).offset(-self.likeView.selfSize.width)
//            }
//            self.contentView.layoutIfNeeded()
//        }
//    }
//    func disMissLikeView() {
//        UIView.animate(withDuration: 0.25) {
//            self.likeView.snp.updateConstraints { make in
//                make.left.equalTo(self.rightBgView)
//            }
//            self.contentView.layoutIfNeeded()
//        }
//    }
//    @objc func btnAction(_ btn:UIButton) {
//        guard let model = model else { return }
//        btn.setTitle(model.extendText, for: .normal)
//        model.isExtend = !model.isExtend
//        self.callExtend?()
//        
//        let timeDelay = 0.2
//            
//        DispatchQueue.main.asyncAfter(deadline:.now() + timeDelay) {
//            btn.backgroundColor = UIColor.clear
//        }
//        
//    }
//    @objc func btndownAction(_ btn:UIButton) {
//        btn.backgroundColor = UIColor.GT.bg_e
//    }
//    @objc func btndragAction(_ btn:UIButton) {
//        btn.backgroundColor = .clear
//    }
//    func bindModel(_ model:ShopWXModel?) {
//        guard let model = model else { return }
//        self.model = model
//        nameL.setTitle(model.name, for: .normal)
//        mainL.text = model.content
//        extendBtn.setTitle(model.extendText, for: .normal)
//        extendBgView.isHidden = !model.isNeedExtendView
//        heightContrainst?.update(offset: model.extendHeight)
//        heightMainLContrainst?.update(offset: model.mainLHeight)
//        timeL.text = model.time
//    }
//}

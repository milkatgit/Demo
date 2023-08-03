//
//  BaseLineCell.swift
//  GrainTrade
//
//  Created by milk on 2023/3/29.
//

import UIKit
import SnapKit
import HandyJSON
struct BaseCellLineModel : HandyJSON {
    ///[自定义cell
    var cellType : UITableViewCell.Type?
    //对应的model
    var otherModel : Any?//]
    
    
    var leftText : String?
    var midText : String?
    var rightText : String?
    var leftFontSize : UIFont = UIFont.Normal.font_13
    var leftTextColor : UIColor = UIColor.GT.a8
    var midFontSize : UIFont = UIFont.Normal.font_13
    var midTextColor : UIColor = UIColor.GT.black
    var rightFontSize : UIFont = UIFont.Normal.font_13
    var rightTextColor : UIColor = UIColor.GT.black

    /// 右侧有箭头
    var hasArrowRight = false
    /// (圆角cell首行顶部增加高度)建议设为7 label距离上面为5 (7+5=12)
    var topAdd : CGFloat = 0
    var bottomAdd : CGFloat = 0
    let topAddSuggest:CGFloat = 7
    let bottomAddSuggest:CGFloat = 7

}

class BaseCellLine: BaseCellCorner {
    
    var leftL : UILabel!
    var midL : UILabel!
    var rightL : UILabel!
    var arrowBg : UIView!
    var arrowRight : UIImageView!
    
    var topV : UIView!
    var bottomV : UIView!
    var heightConstraintTop : Constraint?
    var heightConstraintBottom : Constraint?
    var widthConstraintArrowBg : Constraint?

    // 左中label间隔
    var leftMidSpace : CGFloat = 15
    // 可理解为rightL距离右边边距(rightMargin多出的距离)
    var arrowBgWidth : CGFloat = 13
    // 箭头图片宽度
    var arrowImageWidth : CGFloat = 8

    override func setUI() {
        topV = UIView()
        contentView.addSubview(topV)
        
        bottomV = UIView()
        contentView.addSubview(bottomV)
        
        arrowBg = UIView()
        contentView.addSubview(arrowBg)
        arrowRight = UIImageView()
        arrowRight.image = UIImage(named: AppImageName.arrowright.rawValue)?.renderColor(UIColor.GT.black)?.compressWidthWith(arrowImageWidth)
        arrowBg.addSubview(arrowRight)
        
        leftL = UILabel()
        leftL.textColor = UIColor.GT.a8
        leftL.font = UIFont.Normal.font_13
        contentView.addSubview(leftL)
        
        midL = UILabel()
        midL.textColor = UIColor.GT.black
        midL.font = UIFont.Normal.font_13
        contentView.addSubview(midL)
        
        rightL = UILabel()
        rightL.textColor = UIColor.GT.black
        rightL.font = UIFont.Normal.font_13
        contentView.addSubview(rightL)
        
        topV.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            heightConstraintTop = make.height.equalTo(0).constraint
        }
        bottomV.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            heightConstraintBottom = make.height.equalTo(0).constraint
        }
        
        leftL.snp.makeConstraints { make in
            make.top.equalTo(topV.snp.bottom).offset(topMargin())
            make.left.equalTo(leftMargin())
        }
        midL.snp.makeConstraints { make in
            make.left.equalTo(leftL.snp.right).offset(leftMidSpace)
            make.top.equalTo(leftL)
        }
        arrowBg.snp.makeConstraints { make in
            make.right.equalTo(-rightMargin())
            make.centerY.equalTo(leftL)
            widthConstraintArrowBg = make.width.equalTo(arrowBgWidth).constraint
        }
        arrowRight.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalToSuperview()
            
        }
        rightL.snp.makeConstraints { make in
            make.top.equalTo(leftL)
            make.right.equalTo(arrowBg.snp.left)
            make.bottom.equalTo(bottomV.snp.top).offset(-bottomMargin())
        }
        
    }
    
    func refresh(_ model:BaseCellLineModel?) {
        guard let model = model else { return }
        leftL.text = model.leftText ?? " "
        leftL.textColor = model.leftTextColor
        leftL.font = model.leftFontSize
        
        midL.text = model.midText ?? ""
        midL.textColor = model.midTextColor
        midL.font = model.midFontSize
        
        rightL.text = model.rightText ?? " "
        rightL.textColor = model.rightTextColor
        rightL.font = model.rightFontSize
        //样式更新
        arrowBg.isHidden = !model.hasArrowRight
        widthConstraintArrowBg?.update(offset: model.hasArrowRight ? arrowBgWidth : 0)
        heightConstraintTop?.update(offset: model.topAdd)
        heightConstraintBottom?.update(offset: model.bottomAdd)
    }

    func topMargin() -> CGFloat {
        return kMargin_5
    }
    func bottomMargin() -> CGFloat {
        return kMargin_5
    }
    func leftMargin() -> CGFloat {
        return kMargin
    }
    func rightMargin() -> CGFloat {
        return kMargin
    }
}

class BaseCellLineSection: BaseCellCorner {
    
    var lineMiddle : UIView!
    var lineMiddleR : UIView!
    var labelMiddle : UILabel!
    
    override func setUI() {
        super.setUI()
        lineMiddle = UIView()
        lineMiddle.backgroundColor = UIColor.TableView.separatorline
        contentView.addSubview(lineMiddle)
        lineMiddleR = UIView()
        lineMiddleR.backgroundColor = UIColor.TableView.separatorline
        contentView.addSubview(lineMiddleR)
  
        labelMiddle = UILabel()
        labelMiddle.textColor = UIColor.GT.gray_6
        labelMiddle.font = UIFont.Normal.font_notes_12
        labelMiddle.textAlignment = .center
        contentView.addSubview(labelMiddle)
 
        labelMiddle.snp.makeConstraints { make in
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.center.equalToSuperview()
        }
        lineMiddle.snp.makeConstraints { make in
            make.left.equalTo(kMargin*2)
            make.right.equalTo(labelMiddle.snp.left).offset(-kMargin*2)
            make.centerY.equalTo(labelMiddle)
            
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        lineMiddleR.snp.makeConstraints { make in
            make.right.equalTo(-kMargin*2)
            make.left.equalTo(labelMiddle.snp.right).offset(kMargin*2)
            make.centerY.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
    
    func refresh(_ model:BaseCellLineModel?) {
        guard let model = model else { return }
        labelMiddle.text = model.leftText
    }

}

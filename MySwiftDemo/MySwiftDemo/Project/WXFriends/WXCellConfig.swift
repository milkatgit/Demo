//
//  WXCellConfig.swift
//  GrainTrade
//
//  Created by milk on 2023/3/6.
//

import UIKit

/// cell的信息在这里定义 model和cell都从这里取配置信息
class WXCellConfig {
    static let shared = WXCellConfig()
    var headerH:CGFloat = 40.0
    /// 边距
    var margin = kMargin
    /// subview横竖间隔
    var margin_10 = kMargin_10
    let nameLHeight:CGFloat = 15.0
    let extendBtnHeight :CGFloat = 15.0
    let timeLHeight :CGFloat = 15.0
    let 全文 = "全文"
    let 收起 = "收起"
    var font = UIFont.Normal.font_content_14
    /// 超过行数显示全文
    var numberOfLine = 3
    /// 全文按钮 bgView的高度(隐藏更新高度用)
    var extendBtnSuperViewHeight:CGFloat {
        return margin_10 + extendBtnHeight
    }
    /// 可变高度label宽度
    var mutableLinesLabelWidth:CGFloat {
        return kScreenWidth - (margin * 2 + headerH + margin_10)
    }
    /// 固定行数的label高度
    lazy var fixLineHeight:CGFloat = {
        let h = getFixLineLabelHeight(mutableLinesLabelWidth, font: font, numberOfLines: numberOfLine)
        return h
    }()
    func getFixLineLabelHeight(_ caculateWidth:CGFloat,font:UIFont,numberOfLines:Int) -> CGFloat {
        return getLabelHeight(caculateWidth, font: font, numberOfLines: numberOfLines, text: "")
    }
    func getNoLimitLineLabelHeight(_ caculateWidth:CGFloat,font:UIFont,text:String) -> CGFloat {
        return getLabelHeight(caculateWidth, font: font, numberOfLines: 0, text: text)
    }
    private func getLabelHeight(_ caculateWidth:CGFloat,font:UIFont,numberOfLines:Int,text:String) -> CGFloat {
        let l = UILabel()
        l.frame = CGRect(x: 0, y: 0, width: caculateWidth, height: .greatestFiniteMagnitude)
        l.font = font
        l.numberOfLines = numberOfLines
        var caculateText = text
        if numberOfLines > 0 {
            for _ in 0..<numberOfLines {
                caculateText += "哈\n"
            }
        }
        l.text = caculateText
        l.sizeToFit()
//        print("宽度:\(mutableLinesLabelWidth)-font:\(font.pointSize)-行数:\(numberOfLine)高度=\(l.height)")
        return l.height
    }
    
    func createDatas() -> [ShopWXModel] {
        var names = ["james","lufei","BYD","Tesla","suolong","gaohe","xiaop","weilai","lixiang","jinke"]
        var texts = ["上月底，微信团队发布了iOS微信8.0.33正式版，才过了没几天，今天iOS微信8.0.34内测版又迎来了更新，可以说是非常快了，不过iOS微信内测都是有名额限制的，而且下载名额已满，无法通过内测渠道进行下载。但是芝麻妹给大家带来了安装包下载，并且不会覆盖原版微信，感兴趣的小伙伴一起来看看吧！","本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。","推荐表情开关开启后，在输入框输入","点击“隐私”可以调整“识别已添加的表情用于推荐”和“表情个性化推荐”开关。","在iOS微信8.0.34内测版中，二维码样式回滚，又彩色回滚到了黑白色。","本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。","本次内测版中，在“我”-“设置”。","本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据。","本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。本次内测版中，在“我”-“设置”-“消息通知”界面，可以看到，“视频号和直播推送”功能被取消了，本来可以根据自己需求来控制手机是不是要接收视频直播，这下就算你不看也要接收了。","the end"]
        var arr = [ShopWXModel]()
        names += names
        texts += texts
        for index in 0..<20 {
            let model = ShopWXModel()
            model.name = names[index]
            model.content = texts[index]
            model.time = "3天前"
            arr.append(model)
        }
        return arr
    }
}

class ShopWXModel {

//    required init() { }
    var header : String?
    var name : String?
    var content : String?
    var time : String?
    
    
    var cellInfo = WXCellConfig.shared
    /// 文本总高度
    lazy var afterContentFullHeight :CGFloat = {
        guard let content = content,content.isEmpty == false else { return 0 }
//        let lSize = (content as NSString).boundingRect(with: CGSize(width: cellInfo.mutableLinesLabelWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font:cellInfo.font as Any], context: nil)
//        print("realH=\(lSize.height)")
//        let h = ceil(lSize.height) + 1
        let h = cellInfo.getNoLimitLineLabelHeight(cellInfo.mutableLinesLabelWidth, font: cellInfo.font, text: content)
        return h
    }()
    
    // lazy
    lazy var isNeedExtendView : Bool = {
        if afterContentFullHeight > cellInfo.fixLineHeight {
            return true
        }
        return false
    }()
    var isExtend = false {
        didSet {
            extendText = isExtend ? cellInfo.收起 : cellInfo.全文
        }
    }
    var mainLHeight : CGFloat {
        var x:CGFloat = 0
        if isNeedExtendView {
         
            if isExtend {
                x += afterContentFullHeight
            }else {
                x += cellInfo.fixLineHeight
            }
        }else {
            x += afterContentFullHeight
        }
        return x
    }
    var extendHeight : CGFloat {
        if isNeedExtendView {
            return cellInfo.extendBtnSuperViewHeight
        }
        return 0
    }
    var extendText : String = WXCellConfig.shared.全文
    
    
    var cellHeight : CGFloat {
        // 昵称
        var x = cellInfo.margin + cellInfo.nameLHeight + cellInfo.margin_10
        //内容label
        x += mainLHeight + cellInfo.margin_10
        //全文部分
        x += extendHeight
        // 时间
        x += cellInfo.timeLHeight + cellInfo.margin
        return x
    }
    
    
}

extension UILabel {
    var isTruncated:Bool {
        guard let text = text else { return false }
        let lSize = (text as NSString).boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font:font as Any], context: nil)
        return lSize.height > bounds.size.height
    }
    
}

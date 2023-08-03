//
//  UIColor+extentions.swift
//  GrainTrade
//
//  Created by milk on 2023/4/24.
//

import UIKit


extension UIColor {
    struct Price {
        static let red = #colorLiteral(red: 0.9058823529, green: 0.3294117647, blue: 0.3450980392, alpha: 1) // 突出红
        static let green = #colorLiteral(red: 0.06274509804, green: 0.5725490196, blue: 0.3882352941, alpha: 1)
    }

    struct TableView {
        static let separatorline = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    /// GrainTrade
    struct GT {
        static let app = #colorLiteral(red: 0.4039215686, green: 0.6588235294, blue: 0.4470588235, alpha: 1) //主色调
        static let app_less = #colorLiteral(red: 0.6, green: 0.8, blue: 0, alpha: 1) //次色调
        static let yellow_less = #colorLiteral(red: 0.8, green: 0.6274509804, blue: 0.3450980392, alpha: 1) //标题辅助色
        static let yellow = #colorLiteral(red: 0.9607843137, green: 0.6039215686, blue: 0.137254902, alpha: 1) //强调黄
        static let yellow_tip = #colorLiteral(red: 1, green: 1, blue: 0.6, alpha: 1) //提示背景
        static let gray_3 = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)//前景黑
        static let gray_6 = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)//前景灰
        static let a8 = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)//辅助背景
        static let bg_e = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)//背景灰
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//区块背景
        static let red = #colorLiteral(red: 0.8509803922, green: 0, blue: 0.1058823529, alpha: 1)//突出红
        static let blue = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 1, alpha: 1)//超链
        static let black = #colorLiteral(red: 0.1019607843, green: 0.1019607843, blue: 0.1019607843, alpha: 1) //"1A1A1A" 京东黑色字体

    }
}

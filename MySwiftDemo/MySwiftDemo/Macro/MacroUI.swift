//
//  Common+UI.swift
//  QSwift
//
//  Created by QDong on 2021/7/4.
//

import UIKit
import Foundation

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kStatusBarHeight: CGFloat = UIDevice.vg_statusBarHeight()
let kNavBarHeight: CGFloat = kStatusBarHeight + 44.0
let kSafeBottom : CGFloat = UIDevice.vg_safeDistanceBottom()
/// 不加安全区
let kTabbarHeight : CGFloat = 49.0
/// 加上安全区
let kTabBarFullHeight: CGFloat = kSafeBottom + kTabbarHeight

let kWindow = UIApplication.shared.windows.first!
let kMargin : CGFloat = 12.0
let kMargin_5 : CGFloat = 5.0
let kMargin_10 : CGFloat = 10.0
let kTableViewSectionHeight : CGFloat = 35.0

let kCornerRadius : CGFloat = 10.0
var isSimulator : Bool {
    if TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1 {
        return true
    }
    return false
}




// 计算String的高度
func measureHeight(text: String?, maxWidth: CGFloat, font: UIFont?, lineSpacing: CGFloat) -> CGFloat {
    return measureSize(text: text, maxWidth: maxWidth, font: font, lineSpacing: lineSpacing).size.height
}

// 计算String的高度
func measureSize(text: String?, maxWidth: CGFloat, font: UIFont?, lineSpacing: CGFloat) -> CGRect {
    
    guard let text = text else {
        return CGRect.zero
    }
    
    let calSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = .byWordWrapping
    paragraphStyle.lineSpacing = lineSpacing

    let attributes = [
        NSAttributedString.Key.font: font,
        NSAttributedString.Key.paragraphStyle: paragraphStyle
    ]
    
    let rect = text.boundingRect(
        with: calSize,
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        attributes: attributes as [NSAttributedString.Key : Any],
        context: nil)
    
    return rect
}

// 计算AttributedString的高度
func measureSize(attributedString: NSAttributedString?, maxWidth: CGFloat) -> CGSize {
    
    guard let attributedString = attributedString else {
        return CGSize.zero
    }
    
    let frame = attributedString.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    
    //+1 是因为我发现NSAttributedString如果有图片，会出现就差1像素就能显示全的bug
    return CGSize.init(width: frame.size.width + 1, height: frame.size.height + 1)
}


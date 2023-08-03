//
//  StringExtention.swift
//  MySwiftDemo
//
//  Created by milk on 2023/5/29.
//

import UIKit

extension String {
    /// 固定宽度计算高度
    func height(font:UIFont,widthMax:CGFloat) -> CGFloat {
        let size = CGSize(width: widthMax, height: .greatestFiniteMagnitude)
        //,.usesFontLeading,.truncatesLastVisibleLine
        let rect = self.boundingRect(with: size,
                                     options: [.usesLineFragmentOrigin],
                                  attributes: [NSAttributedString.Key.font: font],
                                  context: nil).integral
        return rect.height
    }
//    func height(font:UIFont,widthMax:CGFloat) -> CGFloat {
//        let l = UILabel()
//        l.frame = CGRect(x: 0, y: 0, width: widthMax, height: .greatestFiniteMagnitude)
//        l.font = font
//        l.numberOfLines = 0
//        l.text = self
//        l.sizeToFit()
//        return l.size.height
////        let size = l.sizeThatFits(CGSize(width: widthMax + 100, height: .greatestFiniteMagnitude))
////        return ceil(size.height)
//    }
}

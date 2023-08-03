//
//  UIFont+extention.swift
//  GrainTrade
//
//  Created by milk on 2023/4/24.
//

import UIKit

extension UIFont {
    struct Bold {
        static let font_15 = UIFont.boldSystemFont(ofSize:15)
        static let font_17 = UIFont.boldSystemFont(ofSize:17)
        static let font_18 = UIFont.boldSystemFont(ofSize:18)
        static let font_25 = UIFont.boldSystemFont(ofSize:25)
        
    }
    struct Normal {
        static let font_title_17 = UIFont.systemFont(ofSize:17)//标题
        static let font_content_14 = UIFont.systemFont(ofSize:14)//内容
        static let font_13 = UIFont.systemFont(ofSize:13)//
        static let font_notes_12 = UIFont.systemFont(ofSize:12)//备注
        static let font_time_9 = UIFont.systemFont(ofSize:9.5)//时间标签。。。
    }
    
    struct Nav {
        static let font_title = UIFont.boldSystemFont(ofSize:20)
        static let font_btn = UIFont.boldSystemFont(ofSize:16)
    }
    struct Tabbar {
        static let font = UIFont.systemFont(ofSize:12)
    }
}

//
//  CurrentNavViewControllerExtention.swift
//  MySwiftDemo
//
//  Created by milk on 2023/5/20.
//

import UIKit
/// 获取当前导航控制器

extension UIView {
    var currentNavViewController : UINavigationController? {
        var n = next
        while n != nil {
            if n is UINavigationController {
                return n as? UINavigationController
            }
            n = n?.next
        }
        return nil
    }
    
}

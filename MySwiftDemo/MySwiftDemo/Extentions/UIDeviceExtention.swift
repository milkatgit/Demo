//
//  UIDeviceExtention.swift
//  GrainTrade
//
//  Created by milk on 2022/6/23.
//

import UIKit

extension UIDevice {
    /// 顶部安全区高度
       static func vg_safeDistanceTop() -> CGFloat {
//           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let window = windowScene.windows.first else { return 0 }
               return window.safeAreaInsets.top
//           } else if #available(iOS 11.0, *) {
//               guard let window = UIApplication.shared.windows.first else { return 0 }
//               return window.safeAreaInsets.top
//           }
//           return 0;
       }
       
       /// 底部安全区高度
       static func vg_safeDistanceBottom() -> CGFloat {
//           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let window = windowScene.windows.first else { return 0 }
               return window.safeAreaInsets.bottom
//           } else if #available(iOS 11.0, *) {
//               guard let window = UIApplication.shared.windows.first else { return 0 }
//               return window.safeAreaInsets.bottom
//           }
//           return 0;
       }
       
       /// 顶部状态栏高度（包括安全区）
       static func vg_statusBarHeight() -> CGFloat {
           var statusBarHeight: CGFloat = 0
//           if #available(iOS 13.0, *) {
               let scene = UIApplication.shared.connectedScenes.first
               guard let windowScene = scene as? UIWindowScene else { return 0 }
               guard let statusBarManager = windowScene.statusBarManager else { return 0 }
               statusBarHeight = statusBarManager.statusBarFrame.height
//           } else {
//               statusBarHeight = UIApplication.shared.statusBarFrame.height
//           }
           return statusBarHeight
       }
}

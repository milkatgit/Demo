//
//  ZMBaseViewController.swift
//  GrainTrade
//
//  Created by milk on 2023/3/27.
//

import UIKit
import HandyJSON
//struct ZMBaseModel : HandyJSON {
//    /// 用来比较相等的字段(订单号)
//    var equalId : String = ""
//    
//}

class ZMBaseVC: UIViewController {
    deinit {
        print("deinit-\(self)")
    }
    var loadingText = "正在加载..."
    lazy var loadingView: UIImageView = {
        var images = [UIImage]()
        for i in 0..<4 {
            let imgName = "cm2_list_icn_loading" + "\(i+1)"
            
            let img = changeColor(image: UIImage(named: imgName)!, color: UIColor.rgbColor(r: 200, g: 38, b: 39))
            images.append(img)
        }
        
        for i in (0..<4).reversed() {
            let imgName = "cm2_list_icn_loading" + "\(i+1)"
            
            let img = changeColor(image: UIImage(named: imgName)!, color: UIColor.rgbColor(r: 200, g: 38, b: 39))
            images.append(img)
        }
        
        let loadingView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
        loadingView.animationImages = images
        loadingView.animationDuration = 0.75
        loadingView.isHidden = true
        
        return loadingView
    }()
    var loadingSuperView : UIView?
    
    lazy var loadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.gray
        label.text = loadingText
        label.isHidden = true
        
        return label
    }()
    lazy var nav : BaseNav! = {
        let n = BaseNav()
        n.backgroundColor = UIColor.GT.app
        n.backCall = {[weak self] in
            if let nav = self?.navigationController {
                if nav.viewControllers.count > 1 {
                    self?.navigationController?.popViewController(animated: true)
                }else if nav.viewControllers.count == 1 {
                    if (self?.presentingViewController != nil) {
                        self?.dismiss(animated: true)
                    }
                }
            }else {
                if (self?.presentingViewController != nil) {
                    self?.dismiss(animated: true)
                }else {
                    print("没有导航 也没有present?")
                }
            }
            HUD.hide()
        }
        return n
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let t = titleForNav() {
            self.view.addSubview(nav)
            nav.titleL.text = t
            nav.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(kNavBarHeight)
            }
        }
        //addLoadingView()
    }
    //MARK: - 添加到最顶层view nil->self.view
    func addLoadingViewTo(view:UIView?=nil) {
        let superView = view ?? self.view!
        self.loadingSuperView = superView
        superView.addSubview(self.loadingView)
        superView.addSubview(self.loadLabel)
        self.loadingView.snp.makeConstraints { (make) in
            make.top.equalTo(superView).offset(40.0)
            make.centerX.equalToSuperview()
        }
        
        self.loadLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.loadingView.snp.bottom).offset(10.0)
            make.centerX.equalTo(self.loadingView)
        }
    }
    func bringLoadingViewToFront() {
        let superView = self.view!
        self.loadingSuperView = superView
        superView.addSubview(self.loadingView)
        superView.addSubview(self.loadLabel)
        self.loadingView.snp.makeConstraints { (make) in
            let h = ifHaveCustomNav() ? kNavBarHeight : 0
            make.top.equalTo(superView).offset(40.0+h)
            make.centerX.equalToSuperview()
        }
        
        self.loadLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.loadingView.snp.bottom).offset(10.0)
            make.centerX.equalTo(self.loadingView)
        }
        self.view.bringSubviewToFront(self.loadingView)
        self.view.bringSubviewToFront(self.loadLabel)
    }
    /// type 0->自定义 1->MBProgress样式
    func showLoading(_ type:Int = 0) {
        DispatchQueue.main.async {
            if let loadingSuperView = self.loadingSuperView {
                if type == 0 {
                    self.loadingView.isHidden = false
                    self.loadLabel.isHidden = false
                    self.loadingView.startAnimating()
                }else {
                    HUD.share().showLoding(self.loadingText, to: loadingSuperView)
                }
            }
        }
    }
    
    func hideLoading() {
        if let loadingSuperView = loadingSuperView {
            self.loadingView.isHidden = true
            self.loadLabel.isHidden = true
            self.loadingView.stopAnimating()
            MBProgressHUD.hide(for: loadingSuperView, animated: true)
        }
    }
    
    /// 自定义navView情况 tableview 起点高度
    func ifHaveCustomNav() -> Bool { true }
    func titleForNav() -> String? { nil }
    

    public func changeColor(image: UIImage, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIRectFill(bounds)
        image.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
}

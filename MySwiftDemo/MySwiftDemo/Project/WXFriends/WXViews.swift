//
//  WXViews.swift
//  GrainTrade
//
//  Created by milk on 2023/3/6.
//

import UIKit


class WXLikeView: UIView {
    struct ItemInfo {
        var title = ""
        var imageName = ""
        
    }
    let selfSize = CGSize(width: 140, height: 25)
    
    var datas = [ItemInfo]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let item = ItemInfo(title: "赞", imageName: ImageSet.mine_collect.rawValue)
        let item1 = ItemInfo(title: "评论", imageName: ImageSet.mine_collect.rawValue)
        datas = [item,item1]
        self.bounds = CGRect(x: 0, y: 0, width: selfSize.width, height: selfSize.height)
        self.backgroundColor = .black.withAlphaComponent(0.5)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        let btnW = selfSize.width / 2
        let btnH = selfSize.height
        for (index,item) in datas.enumerated() {
            let btn = UIButton()
            btn.setTitle(item.title, for: .normal)
            let image = UIImage(named: item.imageName)?.renderColor(.white)
            btn.setImage(image, for: .normal)
            addSubview(btn)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.Normal.font_content_14
            btn.frame = CGRect(x: CGFloat(index)*btnW, y: 0, width: btnW, height: btnH)
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
        }
        let line = UIView()
        line.backgroundColor = .black
        addSubview(line)
        line.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(3)
            make.width.equalTo(1/UIScreen.main.scale)
        }
    }
    @objc func btnAction(_ btn:UIButton) {
        print("=\(btn.currentTitle!)")
    }
}

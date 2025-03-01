//
//  EmptyFriendView.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/3/2.
//

import UIKit

class EmptyFriendView : UIView {
    
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
}

fileprivate extension EmptyFriendView {
    
    func initView() -> Void {
        let view = Bundle.main.loadNibNamed("\(EmptyFriendView.self)", owner: self, options: nil)!.first as! UIView
        view.frame = bounds
        addSubview(view)
        
        setupGradientBackgroundAndShadow()
    }
    
    /** 設定漸層與陰影 */
    func setupGradientBackgroundAndShadow() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.frogGreen.cgColor, UIColor.booger.cgColor] // 設定漸層顏色
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // 左側開始
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // 右側結束
        gradientLayer.frame = self.button.bounds
        gradientLayer.cornerRadius = 20
        self.button.layer.insertSublayer(gradientLayer, at: 1)
        self.button.layer.shadowColor = UIColor.appleGreen40.cgColor
        self.button.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.button.layer.shadowRadius = 8
    }
}

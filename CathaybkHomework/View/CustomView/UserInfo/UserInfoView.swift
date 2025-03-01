//
//  UserInfo.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/3/1.
//

import UIKit

class UserInfoView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kokoIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initView()
    }
    
    private func initView() {
        let view = Bundle(for: UserInfoView.self).loadNibNamed("\(UserInfoView.self)", owner: self, options: nil)!.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
}

extension UserInfoView {
    func setData(user: User) -> Void {
        self.nameLabel.text = user.name
        if let id = user.kokoid {
            self.kokoIdLabel.text = "KOKO ID : \(id)"
        }
    }
}

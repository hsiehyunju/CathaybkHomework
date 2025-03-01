//
//  FriendInviteItemView.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/3/1.
//

import UIKit

class FriendInviteItemView : UIView {
    @IBOutlet weak var usernameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initView()
    }
    
    private func initView() {
        let view = Bundle(for: FriendInviteItemView.self).loadNibNamed("\(FriendInviteItemView.self)", owner: self, options: nil)!.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
}

extension FriendInviteItemView {
    func setData(userName: String) -> Void {
        self.usernameLabel.text = userName
    }
}

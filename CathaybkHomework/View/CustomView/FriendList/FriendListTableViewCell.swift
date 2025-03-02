//
//  FriendListTableViewCell.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/3/1.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
}

extension FriendListTableViewCell {
    
    func initView() -> Void {
        self.transferBtn.layer.borderColor = UIColor.tabSelected.cgColor
        self.inviteBtn.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setData(friend: Friend) -> Void {
        self.nameLabel.text = friend.name
        self.startImg.isHidden = friend.isHideTopImg()
        
        if (friend.isInvite()) {
            self.moreBtn.isHidden = true
            self.inviteBtn.isHidden = false
        } else {
            self.moreBtn.isHidden = false
            self.inviteBtn.isHidden = true
        }
    }
}

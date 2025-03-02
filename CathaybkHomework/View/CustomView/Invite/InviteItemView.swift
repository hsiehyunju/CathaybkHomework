//
//  InviteItemView.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/3/2.
//

import UIKit

class InviteItemView : UITableViewCell {
   @IBOutlet weak var usernameLabel: UILabel!
}

extension InviteItemView {
    func setData(friend: Friend) -> Void {
        self.usernameLabel.text = friend.name
    }
}

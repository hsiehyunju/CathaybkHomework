//
//  FriendModel.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

struct FriendModel: Decodable {
    var response: [Friend]
}

struct Friend: Decodable {
    var name: String
    var status: Int
    var isTop: String
    var fid: String
    var updateDate: String
}

extension Friend {
    
    /* 是否顯示星號 */
    func isHideTopImg() -> Bool {
        return isTop == "0"
    }
    
    /** 是否已經送出邀請 */
    func isInvite() -> Bool {
        return status == 2
    }
}

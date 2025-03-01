//
//  EFriendRequestType.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/17.
//

/**
 好友列表頁請求 Api 類型
 */
enum EFriendRequestType : CaseIterable {
    /** 僅有好友 */
    case OnlyFriend
    /** 好友和邀請 */
    case FriendAndInvite
    /** 沒有好友 */
    case NoFriend
}

extension EFriendRequestType {
    func toString() -> String {
        switch self {
        case .OnlyFriend:
            return "僅有好友"
        case .FriendAndInvite:
            return "好友和邀請"
        case .NoFriend:
            return "沒有好友"
        }
    }
}

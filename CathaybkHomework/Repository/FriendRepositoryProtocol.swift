//
//  ApiServiceProtocol.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/17.
//

import Foundation
import Combine

protocol FriendRepositoryProtocol {
    
    /**
     請求使用者資訊
     */
    func fetchUserInfo() -> AnyPublisher<UserModel, Error>
    
    /**
     請求只有好友資訊
     */
    func fetchOnlyFriendListData() -> AnyPublisher<[Friend], Error>
    
    /**
     請求好友跟邀請資訊
     */
    func fetchFriendAndInviteData() -> AnyPublisher<FriendModel, Error>
    
    /**
     請求空的好友列表
     */
    func fetchEmptyFriendData() -> AnyPublisher<FriendModel, Error>
}

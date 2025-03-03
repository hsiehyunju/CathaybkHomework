//
//  FriendViewModel.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

import Foundation
import Combine

class FriendViewModel : BaseViewModel {
    
    @Published var userInfo: User? = nil
    @Published var friends: [Friend] = []
    @Published var filterFriend: [Friend] = []
    @Published var inviteList: [Friend] = []
    
    private let repository: FriendRepositoryProtocol

    // MARK: - 初始化 Repository
    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }
    
    /**
     請求使用者資訊
     */
    func fetchUserInfo() -> Void {
        self.userInfo = nil
        self.showLoading()
        
        repository.fetchUserInfo()
            .sink(receiveCompletion: { _ in
                self.hideLoading()
            }, receiveValue: { rsData in
                if let user = rsData.response.first {
                    self.userInfo = user
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchFriendList(requestType: EFriendRequestType) -> Void {
        self.friends.removeAll()
        
        self.showLoading()
        switch requestType {
        case .OnlyFriend:
            self.fetchOnlyFriend()
            break
        default:
            self.fetchOtherType(requestType: requestType)
            break
        }
    }
    
    private func fetchOnlyFriend() -> Void {
        repository.fetchOnlyFriendListData()
            .map { friendArray in
                // 用 Dictionary 去重，保留 `updateDate` 最大的資料
                let uniqueFriends = Dictionary(grouping: friendArray, by: { $0.fid })
                    .compactMapValues { friends in
                        friends.max(by: { $0.updateDate < $1.updateDate }) // 取 updateDate 最大的
                    }
                    .values // 取出 Dictionary 內的值
                return Array(uniqueFriends) as [Friend]
            }
            .sink(receiveCompletion: { _ in
                self.hideLoading()
            }, receiveValue: { friendArray in
                if let array = friendArray as? [Friend] {
                    self.friends = array
                    self.filterFriend = self.friends
                    self.inviteList = array.filter { $0.hasRequestInvite() }
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchOtherType(requestType: EFriendRequestType) -> Void {
        let publisher = if (requestType == .NoFriend) {
            repository.fetchEmptyFriendData()
        } else {
            repository.fetchFriendAndInviteData()
        }
        
        publisher
            .sink(receiveCompletion: { _ in
                self.hideLoading()
            }, receiveValue: { friendArray in
                if let array = friendArray.response as? [Friend] {
                    self.friends = array
                    self.filterFriend = self.friends
                    self.inviteList = array.filter { $0.hasRequestInvite() }
                }
            })
            .store(in: &cancellables)
    }
    
    func filterFriend(input: String) -> Void {
        self.filterFriend.removeAll()
        if (input.isEmpty) {
            self.filterFriend = self.friends
        } else {
            let result = friends.filter {
                $0.name.contains(input.lowercased())
            }
            self.filterFriend.removeAll()
            self.filterFriend = result
        }
    }
}

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
            .delay(for: .seconds(2), scheduler: DispatchQueue.global())
            .sink(receiveCompletion: { _ in
                print("completion")
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
                self.friends = friendArray
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
                self.friends = friendArray.response
            })
            .store(in: &cancellables)
    }
    
    func filterFriend(input: String) -> Void {
        
    }
}

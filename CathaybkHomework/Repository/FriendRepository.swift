//
//  APIService.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

import Foundation
import Combine

class FriendRepository : FriendRepositoryProtocol {
    
    private let userApiUrl = "https://dimanyen.github.io/man.json"
    private let friendListFirstApiUrl = "https://dimanyen.github.io/friend1.json"
    private let firendListSecondApiUrl = "https://dimanyen.github.io/friend2.json"
    private let firendAndInviteListApiUrl = "https://dimanyen.github.io/friend3.json"
    private let emptyFriendListApiUrl = "https://dimanyen.github.io/friend4.json"
    
    func fetchUserInfo() -> AnyPublisher<UserModel, any Error> {
        let url = URL(string: userApiUrl)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchOnlyFriendListData() -> AnyPublisher<[Friend], any Error> {
        // 合併兩個 API 回傳的朋友列表
        return Publishers.Zip(
            fetchFriendFromFirstApi(),
            fetchFriendFromSecondApi()
        ).map { friendModelFirst, friendModelSecond in
            return friendModelFirst.response + friendModelSecond.response
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchFriendFromFirstApi() -> AnyPublisher<FriendModel, any Error> {
        return self.request(url: friendListFirstApiUrl)
    }
    
    private func fetchFriendFromSecondApi() -> AnyPublisher<FriendModel, any Error> {
        return self.request(url: firendListSecondApiUrl)
    }
    
    func fetchFriendAndInviteData() -> AnyPublisher<FriendModel, any Error> {
        return self.request(url: firendAndInviteListApiUrl)
    }
    
    func fetchEmptyFriendData() -> AnyPublisher<FriendModel, any Error> {
        return self.request(url: emptyFriendListApiUrl)
    }
    
    /**
     請求 Api 共用
     */
    private func request<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
        guard let requestURL = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: requestURL)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

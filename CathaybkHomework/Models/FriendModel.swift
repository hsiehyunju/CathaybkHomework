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

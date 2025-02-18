//
//  UserModel.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

struct UserModel: Decodable {
    var response: [User]
}

struct User: Decodable {
    var name: String
    var kokoid: String?
}

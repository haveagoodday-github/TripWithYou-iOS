//
//  ContactModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation

struct ContactRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [ContactModel]
}
struct ContactModel: Decodable {
    let userId: Int
    let avatar: String
    let nickname: String
    let lastMessageContent: String
    let lastMessageTime: String
    let lastOnlineTime: String
}

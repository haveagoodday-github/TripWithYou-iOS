//
//  ChatModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation


struct ChatRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [ChatModel]?
}

struct ChatModel: Decodable, Encodable, Equatable {
    let messageId: Int
    var userId: Int
    var beUserId: Int
    var content: String
    let state: Int
    let createTime: String
    let updateTime: String
    let type: Int
}

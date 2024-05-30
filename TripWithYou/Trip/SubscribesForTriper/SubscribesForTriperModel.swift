//
//  MyPostTripsModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation

struct MyPostTripsRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [MyPostTripsModel]?
}

struct MyPostTripsModel: Decodable {
    let tripId: Int
    let title: String
    let background: String
    let auditStatus: Int
    let totalSubscriptions: Int
    let lastSubscribeUpdateTime: String?
}


struct SubscribesUserInfoRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [SubscribesUserInfoModel]
}

struct SubscribesUserInfoModel: Decodable {
    let updateTime: String
    let avatar: String
    let nickname: String
    let subId: Int
    var status: Int
    let userId: Int
}

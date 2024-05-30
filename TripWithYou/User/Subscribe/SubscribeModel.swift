//
//  SubscribeModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

import Foundation

struct SubscribeRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [SubscribeModel]
}

struct SubscribeModel: Decodable {
    let subId: Int
    let tripId: Int
    let userId: Int
    let title: String
    let background: String
    let updateTime: String
    let status: Int
}


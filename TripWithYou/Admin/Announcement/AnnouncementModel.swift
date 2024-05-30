//
//  AnnouncementModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import Foundation


struct AnnouncementRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [AnnouncementModel]?
}

struct AnnouncementModel: Decodable {
    var title: String
    var content: String
    var createTime: String
    var id: Int
    var userId: Int
}

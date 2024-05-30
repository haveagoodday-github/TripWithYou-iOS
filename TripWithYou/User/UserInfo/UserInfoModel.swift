//
//  UserInfoModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

import Foundation

struct TriperRequestModel: Decodable {
    let code: Int
    let message: String
    var data: TriperModel
}

struct TriperModel: Decodable {
    var id: Int
    var name: String?
    var intro: String?
    var language1: String?
    var language2: String?
    var language3: String?
    var connectionPhone: String?
    
    static let empty = TriperModel(id: 0, name: nil, intro: nil, language1: nil, language2: nil, language3: nil, connectionPhone: nil)
}

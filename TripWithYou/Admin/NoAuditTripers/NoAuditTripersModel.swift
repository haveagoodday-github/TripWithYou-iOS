//
//  NoAuditTripersModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation

struct NotAuditTriperRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [NotAuditTriperModel]
}

struct NotAuditTriperModel: Decodable {
    let triperId: Int
    let name: String?
    let intro: String?
    let language1: String?
    let language2: String?
    let language3: String?
    let connectionPhone: String?
    let userId: Int
    let avatar: String
    let sex: Int
    let birthday: String
    let triperUpdateTime: String
}

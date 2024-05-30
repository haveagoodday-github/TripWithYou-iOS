//
//  NoAuditTripsModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation


struct NoAuditTripsRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [NoAuditTripsModel]
}

struct NoAuditTripsModel: Decodable {
    let tripId: Int
    let triperId: Int
    let title: String
    let background: String
    let language1: String
    let language2: String
    let language3: String
    let triperName: String
    let updateTime: String
}

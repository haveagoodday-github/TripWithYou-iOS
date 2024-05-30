//
//  TripModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation

struct TripRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [TripModel]
}

struct SingleTripRequestModel: Decodable {
    let code: Int
    let message: String
    let data: TripModel
}

struct TripModel: Decodable {
    let tripId: Int
    let triperId: Int
    let userId: Int
    let title: String
    let background: String
    let tripCreateTime: String
    let tripUpdateTime: String
    let triperName: String
    let language1: String
    let language2: String?
    let language3: String?
    let username: String
    let nickname: String
    let avatar: String
    let sex: Int
    let birthday: String
    let averageScore: Double
    let reviewCount: Int
    
    let serviceTitle: String?
    let serviceContent: String?
    let serviceTitle2: String?
    let serviceContent2: String?
    let serviceTitle3: String?
    let serviceContent3: String?
    let tripStartTime: String?
    let tripEndTime: String?
    
    let price: String
    
    let images: String?
    
    
    static let empty = TripModel(tripId: 0, triperId: 0, userId: 0, title: "", background: "", tripCreateTime: "", tripUpdateTime: "", triperName: "", language1: "", language2: "", language3: "", username: "", nickname: "", avatar: "", sex: 0, birthday: "", averageScore: 0, reviewCount: 0, serviceTitle: "", serviceContent: "", serviceTitle2: "", serviceContent2: "", serviceTitle3: "", serviceContent3: "", tripStartTime: "", tripEndTime: "", price: "", images: "")
}



struct EvaluateRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [EvaluateModel]
}

struct EvaluateModel: Decodable {
    let evaluateId: Int
    let isAnonmity: Int
    let userId: Int
    let nickname: String
    let avatar: String
    let content: String
    let score: Int
    let createTime: String
}

//
//  PostTripModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation

enum PostTripForm {
    case title
    case background
}


struct PostTripModel {
    var title: String
    var background: String
    var serviceTitle: String
    var serviceContent: String
    var tripStartTime: Date
    var tripEndTime: Date
    var serviceNum: Int
    var maxServiceNum: Int
    
    var serviceTitle2: String
    var serviceContent2: String
    
    var serviceTitle3: String
    var serviceContent3: String
    
    var price: String
    
}



extension PostTripModel {
    static var empty: PostTripModel = PostTripModel(title: "", background: "", serviceTitle: "", serviceContent: "", tripStartTime: Date(), tripEndTime: Date(), serviceNum: 1, maxServiceNum: 3, serviceTitle2: "", serviceContent2: "", serviceTitle3: "", serviceContent3: "", price: "0")
    
}


struct RealNameModel: Decodable {
    var realname: String
    var realId: String
    
    static let empty: RealNameModel = RealNameModel(realname: "", realId: "")
}


enum realStatus: String {
    case noSubmit = "待提交"
    case waitVer = "待验证"
    case verFailed = "验证不通过"
    case pass = "通过验证"
}





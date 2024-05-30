//
//  ManageUsersModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation


struct ManageUsersRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [ManageUsersModel]
}

struct ManageUsersModel: Decodable {
    let  userId: Int
    let  username: String

    let  nickname: String

    let  email: String?
    let  avatar: String
    let  sex: Int
    var  type: Int
    let  phone: String

    let  dynamicImages: String?

    let  birthday: String?
    let  createTime: String
    let  updateTime: String
}

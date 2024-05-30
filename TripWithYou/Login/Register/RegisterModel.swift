//
//  RegisterModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation

struct RegisterModel {
    var username: String
    var password: String
    var sex: Int?
    var age: Int?
    var email: String?
    var birthday: Data?
    var type: Int
}


enum OnboardingField {
    case username
    case password
    case phone
    case nickname
    
    case email
    
    case newPassword
    
}


struct baseModel: Decodable {
    let code: Int
    let message: String
    let data: String?
}

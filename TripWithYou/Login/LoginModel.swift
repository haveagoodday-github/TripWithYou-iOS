//
//  LoginModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation




struct LoginModel: Decodable {
    let code: Int
    let message: String
    let data: String
}

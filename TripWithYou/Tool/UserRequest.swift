//
//  UserRequest.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation


final class UserRequest {
    class func getUserInfoByUserId(_ userId: Int = UserCache.shared.getUserInfo()?.userId ?? 0, completion: @escaping (UserInfo) -> Void) {
        NetworkTools.requestAPI(convertible: "/user/userInfoByUserId",
                                method: .post,
                                parameters: [
                                    "userId": userId
                                ],
                                responseDecodable: UserInfoRequestModel.self) { result in
            let userinfo = result.data
            if UserCache.shared.getUserInfo()?.userId == userId {
                if UserCache.shared.getUserInfo() != userinfo {
                    UserCache.shared.saveUserInfo(userinfo)
                }
            }
            completion(userinfo)
        } failure: { _ in
            
        }
    }
}

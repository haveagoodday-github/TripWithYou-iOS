//
//  UserCache.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import Foundation
import Alamofire

struct UserInfoRequestModel: Decodable {
    let code: Int
    let message: String
    var data: UserInfo
}
struct UserInfosRequestModel: Decodable {
    let code: Int
    let message: String
    var data: [UserInfo]?
}


struct UserInfo: Decodable, Encodable, Equatable {
    var userId: Int
    var username: String
    var nickname: String
    var phone: String
    var avatar: String
    var type: Int
    var email: String?
    var sex: Int
    var birthday: String?
    var updateTime: String
    var dynamicImages: String?
    var identificationCard: String?
    var realname: String?
    var realStatus: Int?
    
    var createTime: String?
    var updataTime: String?
    
    static let empty = UserInfo(userId: 0, username: "username", nickname: "nickname", phone: "13888888888", avatar: "https://voicechat.oss-cn-shenzhen.aliyuncs.com/logo.jpg", type: 1, sex: 1, birthday: "2024-04-12", updateTime: "2024-04-12", dynamicImages: "", realStatus: 0)
}

class UserCache: ObservableObject {
    @Published var userInfo: UserInfo?
    static let shared = UserCache()

    private let userDefaults = UserDefaults.standard

    private let userKey = "com.tripwithyou.userinfo"


    func saveUserInfo(_ userInfo: UserInfo) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(userInfo)
            userDefaults.set(userData, forKey: userKey)
            self.userInfo = userInfo // Update userInfo property
        } catch {
            print("Error encoding user info: \(error)")
        }
    }

    func getUserInfo() -> UserInfo? {
        if let userData = userDefaults.data(forKey: userKey) {
            do {
                let decoder = JSONDecoder()
                let userInfo = try decoder.decode(UserInfo.self, from: userData)
                return userInfo
            } catch {
                print("Error decoding user info: \(error)")
            }
        }
        return nil
    }

    func clearUserInfo() {
        userDefaults.removeObject(forKey: userKey)
        userInfo = nil
    }
}

//
//  ForgotViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation
import SwiftUI
import ProgressHUD

class ForgotViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var phone: String = ""
    @Published var newPassword: String = ""
    
    
    // 找回密码
    func reset() {
        print(username)
        print(phone)
        print(newPassword)
        NetworkTools.requestAPI(convertible: "/user/updatePassword",
                                method: .post,
                                parameters: [
                                    "username": username,
                                    "phone": phone,
                                    "newPassword": newPassword
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("设置新密码成功")
                self.username = ""
                self.phone = ""
                self.newPassword = ""
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { _ in
            ProgressHUD.error("设置失败")
        }

    }
}

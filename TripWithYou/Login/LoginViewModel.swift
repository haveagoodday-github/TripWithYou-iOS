//
//  LoginViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation
import SwiftUI
import ProgressHUD
import Alamofire

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLogin_user: Bool = false
    @Published var isLogin_trip: Bool = false
    @Published var isLogin_selectIidentity: Bool = false
    @Published var isLogin_admin: Bool = false
    @Published var selectUserType: String = "游客" // TEST
    @Published var selectUserTypeList: [String] = ["游客", "导游", "管理员"] // TEST
    @Published var captchaCode: String = ""
    @Published var captchaKey: String = ""
    @Published var verCode: UIImage? = nil
    
    init() {
        getVerCode()
    }
    
    
    func login() {
        checkCaptcha() {[self] isS in
            if isS {
                login2()
            } else {
                ProgressHUDView.error("验证码错误", 3)
            }
        }
    }
    
    func login2() {
        // 登陆跳转
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        NetworkTools.requestAPI(convertible: "/user/login", method: .post, parameters: parameters, responseDecodable: LoginModel.self) { result in
            if result.code == 0 {
                ProgressHUD.animate("登陆中...")
                UserDefaults.standard.setValue(result.data, forKey: "Authorization")
                self.getUserData()
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { error in
            ProgressHUD.error("登陆失败", delay: 2)
        }
        
    }
    
    func getVerCode() {
        NetworkTools.fetchCaptcha {[self] (image, key) in
            verCode = image
            captchaKey = key!
        }
    }
    
    private func checkCaptcha(completion: @escaping (Bool) -> Void) {
        if captchaCode.isEmpty {
            ProgressHUD.error("验证码不能为空")
            return
        }
        NetworkTools.checkCaptcha(captchaKey: captchaKey, captchaCode: captchaCode) { isSuccess in
            completion(isSuccess)
        }
    }
    
    private func getUserData() {
        ProgressHUD.dismiss()
        
        NetworkTools.requestAPI(convertible: "/user/userInfo",
                                method: .get,
                                responseDecodable: UserInfoRequestModel.self) { result in
            if result.code == 0 {
                UserCache.shared.saveUserInfo(result.data)
                let type = result.data.type
                if type == 0 {
                    self.isLogin_selectIidentity.toggle()
                } else if type == 1 {
                    self.isLogin_user.toggle()
                } else if type == 2 {
                    self.isLogin_trip.toggle()
                    
                } else if type == 3 {
                    // 管理员
                    self.isLogin_admin.toggle()
                }
                ProgressHUD.success("登陆成功", delay: 1.5)
            } else {
                ProgressHUD.failed("登陆失败，无法获取用户数据", delay: 5)
            }
        } failure: { error in
            ProgressHUD.error("登陆失败", delay: 2)
        }
        
    }
    
    
}



struct LanguageModel: Decodable {
    let code: Int
    let message: String
    let data: [data]
    
    struct data: Decodable {
        let id: Int
        let languageName: String
    }
}

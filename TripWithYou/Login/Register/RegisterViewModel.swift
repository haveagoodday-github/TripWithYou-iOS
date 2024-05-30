//
//  RegisterViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation
import SwiftUI
import ProgressHUD


class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var phone: String = ""
    @Published var nickname: String = ""
    @Published var isLogin: Bool = false
    @Published var captchaCode: String = ""
    @Published var captchaKey: String = ""
    @Published var verCode: UIImage? = nil
    
    init() {
        getVerCode()
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
    
    func register() {
        if !validateUserForm() {
            return
        }
        NetworkTools.requestAPI(convertible: "/user/register",
                                method: .post,
                                parameters: [
                                    "username": username,
                                    "password": password,
                                    "nickname": nickname,
                                    "phone": phone
                                ],
                                responseDecodable: baseModel.self) { result in
            print(result.code)
            print(result.message)
            if result.code == 0 {
                self.isLogin.toggle()
                ProgressHUD.success("注册成功")
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { error in
            ProgressHUD.error("注册失败")
        }
    }
    
    
    func validateUserForm() -> Bool {
        if username.isEmpty {
            ProgressHUD.error("用户名不能为空")
            return false
        }
        
        if password.isEmpty {
            ProgressHUD.error("密码不能为空")
            return false
        }
        
        if phone.isEmpty {
            ProgressHUD.error("手机号不能为空")
            return false
        }
        
        if nickname.isEmpty {
            ProgressHUD.error("昵称不能为空")
            return false
        }
        
        if captchaCode.isEmpty {
            ProgressHUD.error("验证码不能为空")
            return false
        }
        
        return true
    }

    
}

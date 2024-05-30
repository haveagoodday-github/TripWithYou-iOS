//
//  ContentView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI
import ProgressHUD

struct ContentView: View {
    var body: some View {
        NavigationView {
            if let userinfo = UserCache.shared.getUserInfo() {
                switch userinfo.type {
                case 1:
                    UserView()
                case 2:
                    TripView()
                case 3:
                    AdminView()
                default:
                    LoginView(isGotoSelectIidentityView: true)
                }
            } else {
                LoginView()
            }
        }
        .onAppear {
            Socket.shared.connect() // 链接Socket
            if let token = UserDefaults.standard.string(forKey: "Authorization") {
                getUserInfo()
                print("用户Token: \(token)")
            }
            print("用户信息: \(UserCache.shared.getUserInfo())")
            
        }
        
    }
    
    private func getUserInfo() {
        NetworkTools.requestAPI(convertible: "/user/userInfo",
                                method: .get,
                                responseDecodable: UserInfoRequestModel.self
        ) { result in
            if result.code == 0 {
                UserCache.shared.saveUserInfo(result.data)
                Socket.shared.write(with: "{'uid': '\(String(UserCache.shared.getUserInfo()!.userId))'}") // 上线
            } else {
                ProgressHUD.failed("登陆失败，无法获取用户数据", delay: 5)
            }
        } failure: { error in
            ProgressHUD.error("登陆失败", delay: 2)
        }
    }

}

#Preview {
    ContentView()
}




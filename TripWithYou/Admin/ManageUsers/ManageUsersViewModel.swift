//
//  ManageUsersViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation
import SwiftUI
import ProgressHUD

class ManageUsersViewModel: ObservableObject {
    @Published private(set) var allUsersArray: [UserInfo] = []
    @Published var isEditUserType: Bool = false
    @Published var currentUserId: Int = 0
    
    init() {
        getAllUsers()
    }
    
    
    func getAllUsers() {
        NetworkTools.requestAPI(convertible: "/admin/getAllUser",
                                method: .get,
                                responseDecodable: UserInfosRequestModel.self) { result in
            if result.code == 0, let data = result.data {
                self.allUsersArray = data
            }
        } failure: { _ in
            
        }

    }
    
    func getActionSheet() -> ActionSheet {
        let userButton: ActionSheet.Button = .default(Text("设置为用户")) {
            self.updateUserType(type: 1)
        }
        let triperButton: ActionSheet.Button = .default(Text("设置为导游")) {
            self.updateUserType(type: 2)
        }
        let adminButton: ActionSheet.Button = .default(Text("设置为管理员")) {
            self.updateUserType(type: 3)
        }
        let blackButton: ActionSheet.Button = .destructive(Text("拉黑此用户")) {
            self.updateUserType(type: 4)
        }
        let cancelButton: ActionSheet.Button = .cancel()
        
        return ActionSheet(title: Text("设置用户类型"),
                    message: Text("用户类型分别为：普通用户、导游、管理员以及黑名单"),
                    buttons: [userButton, triperButton, adminButton, blackButton, cancelButton])
    }
    
    func updateUserType(type: Int) {
        NetworkTools.requestAPI(convertible: "/admin/updateUserType",
                                method: .post,
                                parameters: [
                                    "type": type,
                                    "userId": currentUserId
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                self.modifyUserType(newType: type)
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { _ in
            
        }
    }
    
    func modifyUserType(newType: Int) {
        // 找到第一个匹配userId的元素的索引
        if let index = allUsersArray.firstIndex(where: { $0.userId == currentUserId }) {
            // 更新这个元素的type属性
            allUsersArray[index].type = newType
        }
    }
    
    
    
    
}

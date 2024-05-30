//
//  NoAuditTripersViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation
import SwiftUI
import ProgressHUD

enum realStatusToAdmin: Int, CaseIterable {
    case waitVer = 0
    case verFailed = 2
    case pass = 1
    
}

class NoAuditTripersViewModel: ObservableObject {
    @Published private(set) var tripersArray: [NotAuditTriperModel] = []
    @Published var userlist: [UserInfo] = []
    @Published var managementType: [String] = ["伴游", "未实名用户和导游"]
    @Published var selectedManagementType: String = "伴游"
    
    
    init() {
        getTripers()
    }
    
    func getTripers() {
        NetworkTools.requestAPI(convertible: "/admin/getTripers",
                                method: .get,
                                responseDecodable: NotAuditTriperRequestModel.self) { result in
            if result.code == 0 {
                self.tripersArray = result.data
                if result.data.isEmpty {
                    ProgressHUD.failed("暂无数据")
                }
            }
        } failure: { _ in
            
        }
    }
    
    
    func getUsers(page: Int  = 1) {
        NetworkTools.requestAPI(convertible: "/user/getUncheckedIdentityList",
                                method: .get,
                                parameters: ["page": page],
                                responseDecodable: UserInfosRequestModel.self) { result in
            debugPrint("result: \(result)")
            if let data = result.data {
                self.userlist = data
            }
        } failure: { _ in
            
        }

    }
    
    func auditTriper(triperId: Int, state: Int) {
        NetworkTools.requestAPI(convertible: "/admin/updateTripersAuditStatus",
                                method: .post,
                                parameters: [
                                    "triperId": triperId,
                                    "auditState": state
                                ],
                                responseDecodable: baseModel.self) { result in
            print(result)
            if result.code == 0 {
                withAnimation(.spring) {
                    self.removeTriper(by: triperId)
                }
                if state == 1 {
                    ProgressHUD.succeed("审核通过")
                } else {
                    ProgressHUD.error("不通过", delay: 2)
                }
                
//                self.getTripers() // 刷新
            }
        } failure: { String in
            
        }

    }
    
    private func updateIdentityStatus(_ beUserId: Int, _ status: Int, completion: @escaping () -> Void) {
        NetworkTools.requestAPI(convertible: "/user/updateIdentityStatus",
                                method: .post,
                                parameters: [
                                    "beUserId": beUserId,
                                    "status": status
                                ],
                                responseDecodable: baseModel.self) { result in
            completion()
        } failure: { _ in
            completion()
        }
    }
    
    func updateIdentityStatusAll(completion: @escaping () -> Void) {
        ProgressHUD.animate("更新中")
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "updateIdentityStatus", attributes: .concurrent)
        
        for user in userlist {
            group.enter()
            queue.async {
                self.updateIdentityStatus(user.userId, user.realStatus ?? 0) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    func updateUser(_ user: UserInfo) {
        if let index = userlist.firstIndex(where: { $0.userId == user.userId }) {
            userlist[index] = user
            print("User updated: \(user)")

        }
    }
    
    func removeTriper(by triperId: Int) {
        // 使用filter方法创建一个新数组，排除掉id匹配的元素
        tripersArray = tripersArray.filter { $0.triperId != triperId }
    }
    
}

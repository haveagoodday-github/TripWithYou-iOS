//
//  PersonnelInfoViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/24.
//

import Foundation


class PersonnelInfoViewModel: ObservableObject {
    @Published private(set) var userInfo: UserInfo = .empty
    @Published private(set) var triperInfo: TriperModel = .empty
    @Published var isShowSheet: Bool = false
    @Published var dynamicImages: [String] = []
    
    
    
    func getUserInfo(userId: Int) {
        UserRequest.getUserInfoByUserId(userId) { userinfo in
            DispatchQueue.main.async {
                self.userInfo = userinfo
                print("getUserInfo: \(userinfo)")
                print("current UserInfo: \(self.userInfo)")
            }
            self.dynamicImages = stringToArray(string: userinfo.dynamicImages ?? "")
        }
    }
    
    
    func getTriperInfo(userId: Int) {
        NetworkTools.requestAPI(convertible: "/trip/getSingleTriperInfoByUserId",
                                method: .post,
                                parameters: [
                                    "userId": userId
                                ],
                                responseDecodable: TriperRequestModel.self) { result in
            print("用户基本信息: \(result)")
            if result.code == 0 {
                self.triperInfo = result.data
            }
        } failure: { _ in
            
        }

    }
}

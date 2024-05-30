//
//  UserInfoViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

import Foundation
import SwiftUI
import ProgressHUD


class UserInfoViewModel: ObservableObject {
    @Published private(set) var userInfo: UserInfo = .empty
    @Published private(set) var triperInfo: TriperModel = TriperModel(id: 0, name: nil, intro: nil, language1: nil, language2: nil, language3: nil, connectionPhone: nil)
    @Published var isShowSheet: Bool = false
    
    @Published var isPicker: Bool = false
    
    @Published var avatar: [UIImage] = []
    @Published var nickname: String = ""
    @Published var phone: String = ""
    @Published var sex: Int = 0
    @Published var birthday: Date = Date()
    @Published var email: String = ""
    @Published var avatarUrl: String = ""
    
    
    @Published var name: String = ""
    @Published var connectionPhone: String = ""
    @Published var intro: String = ""
    @Published private(set) var allLanguages: [LanguageModel.data] = []
    @Published var language1: Int = 1
    @Published var language2: Int = 1
    @Published var language3: Int = 1
    
    
    @Published var selectedImageIndex: Int? = nil
    @Published var picker: Bool = false
    @Published var images: [UIImage] = []
    @Published var isShowUpdateButton: Bool = false
//    @Published var updatedImages: [String] = []
    
    @Published var dynamicImages: [String] = []
    
    
    let dateFormatter = DateFormatter()
    
    
    init()  {
        print("UserInfoViewModel")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        getUserInfo()
        if UserCache.shared.getUserInfo()?.type == 2 {
            getTriperInfo()
        }
        
    }
    
    func saveUpdateUserBaseInfo() {
        NetworkTools.requestAPI(convertible: "/trip/updateTriperInfo",
                                method: .post,
                                parameters: [
                                    "name": name,
                                    "intro": intro,
                                    "language1": language1,
                                    "language2": language2,
                                    "language3": language3,
                                    "connectionPhone": connectionPhone
                                ],
                                responseDecodable: baseModel.self) { result in
            self.isShowSheet = false
            self.getTriperInfo()
        } failure: { _ in
            
        }

        
    }
    
    
    func getAllLanguages() {
        NetworkTools.requestAPI(convertible: "/trip/getLanguages",
                                method: .get,
                                responseDecodable: LanguageModel.self) { result in
            print(result.data)
            self.allLanguages = result.data
        } failure: { error in
            
        }
    }
    
    
    func getUserInfo() {
        NetworkTools.requestAPI(convertible: "/user/userInfo",
                                method: .get,
                                responseDecodable: UserInfoRequestModel.self) { result in
            UserCache.shared.saveUserInfo(result.data)
            DispatchQueue.main.async {
                self.userInfo = result.data
                print("getUserInfo: \(result.data)")
                print("current UserInfo: \(self.userInfo)")
            }
            self.avatarUrl = result.data.avatar
            self.nickname = result.data.nickname
            self.phone = result.data.phone
            self.sex = result.data.sex
            if let date = self.dateFormatter.date(from: result.data.birthday ?? "") {
                self.birthday = date
            }
            self.email = result.data.email ?? ""
            
            self.dynamicImages = stringToArray(string: result.data.dynamicImages ?? "")
        } failure: { _ in
            
        }
    }
    
    
    
    func updateUserInfo(completion: @escaping (String) -> Void) {
        let bir = dateFormatter.string(from: self.birthday)

        
        if let imageData = avatar.last {
            print(imageData)
            NetworkTools.uploadImage(image: imageData) { avatarUrl in
                print(avatarUrl)
                NetworkTools.requestAPI(convertible: "/user/update",
                                        method: .post,
                                        parameters: [
                                            "nickname": self.nickname,
                                            "email": self.email,
                                            "phone": self.phone,
                                            "sex": self.sex,
                                            "birthday": bir,
                                            "avatar": avatarUrl
                                        ],
                                        responseDecodable: baseModel.self
                ) { result in
                    if result.code == 0 {
                        ProgressHUD.succeed("保存成功")
                        completion("")
                    }
                } failure: { _ in
                    
                }
            }
        } else {
            NetworkTools.requestAPI(convertible: "/user/update",
                                    method: .post,
                                    parameters: [
                                        "nickname": self.nickname,
                                        "email": self.email,
                                        "phone": self.phone,
                                        "sex": self.sex,
                                        "birthday": bir,
                                        "avatar": self.avatarUrl
                                    ],
                                    responseDecodable: baseModel.self
            ) { result in
                if result.code == 0 {
                    ProgressHUD.succeed("保存成功")
                    completion("")
                }
            } failure: { _ in
                
            }
        }
    }
    
    func disappear() {
        ProgressHUD.dismiss()
    }
    
    func getTriperInfo() {
        NetworkTools.requestAPI(convertible: "/trip/getSingleTriperInfo",
                                method: .get,
                                responseDecodable: TriperRequestModel.self) { result in
            print("用户基本信息: \(result)")
            if result.code == 0 {
                self.triperInfo = result.data
            }
        } failure: { _ in
            
        }

    }
    
    
    func updateData(updatedImages: [String]) {
        // 发起更新请求
        NetworkTools.requestAPI(convertible: "/user/updateDynamicImages",
                                method: .post,
                                parameters: ["dynamicImages": updatedImages],
                                responseDecodable: baseModel.self
        ) { result in
            print(result)
        } failure: { _ in
            // 处理失败情况
        }
    }

    
    func updateDynamicImages(completion: @escaping () -> Void) {
        FileUpdateManager.updateImages(images) { results in
            DispatchQueue.main.async {
//                self.updatedImages = results
                self.isShowUpdateButton = false
                self.getUserInfo()
                self.updateData(updatedImages: results)
                completion()
            }
        }
        
//        var update: CGFloat = 0
//        ProgressHUD.progress("上传图片中...", update)
//        let group = DispatchGroup()
//        let queue = DispatchQueue(label: "uploadImage")
//        
//        for (_, image) in images.enumerated() {
//            group.enter()  // 进入组，表示开始一个任务
//            queue.async {
//                NetworkTools.uploadImage(image: image) { url in
//                    update = update + CGFloat((1 / self.images.count))
//                    ProgressHUD.progress("上传图片中...", update)
//                    self.updatedImages.append(url)  // 保存上传结果
//                    group.leave()  // 任务完成，离开组
//                }
//            }
//        }
//        
//        
//        group.notify(queue: queue) { // 当所有任务完成时执行
//            ProgressHUD.succeed("上传完成")
//            NetworkTools.requestAPI(convertible: "/user/updateDynamicImages",
//                                    method: .post,
//                                    parameters: ["dynamicImages": self.updatedImages],
//                                    responseDecodable: baseModel.self
//            ) { result in
//                print(result)
//            } failure: { _ in
//                
//            }
//            self.updatedImages = self.updatedImages.compactMap { $0 }
//            self.isShowUpdateButton = false
//            self.getUserInfo()
//            completion("")
//        }
//        completion("")
    }
    
}


func stringToArray(string: String) -> [String] {
    if let jsonData = string.data(using: .utf8) {
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] {
                return jsonArray
            }
        } catch {
            print("JSON解析失败: \(error)")
        }
    }
    return []
}

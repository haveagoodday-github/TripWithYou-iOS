//
//  ChatViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/17.
//


import Foundation
import Combine
import UIKit
import SwiftyJSON
import ExyteMediaPicker
import ProgressHUD

class ChatViewModel: ObservableObject {
    @Published var userId: Int = 0
    @Published var messages: [ChatModel] = []
    @Published var newMessages: [ChatModel] = []
    @Published var textMessage: String = ""
    @Published var images: [UIImage] = []
    @Published var videos: [URL] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var select: Bool = false
    @Published var medias: [Media] = []
    @Published var userInfo: UserInfo? = nil
    
    init(userId: Int) {
        self.userId = userId
        getMessagesList()
        subscribeToSocketMessages()
    }
    
    private func getUserInfo() {
        UserRequest.getUserInfoByUserId(userId) { userinfo in
            self.userInfo = userinfo
        }
    }
    
    private func subscribeToSocketMessages() {
        debugPrint("xxx")
        Socket.shared.newMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                debugPrint("接收到消息啦...")
                debugPrint("\(self?.userId) -- \(message.userId) -- be -- \(message.beUserId)")
//                if self?.userId != message.userId {
//                    
//                }
                self?.newMessages.append(message)
            }
            .store(in: &cancellables)
    }
    
    private func getMessagesList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/user/getMessageList",
                                method: .get,
                                parameters: [
                                    "beUserId": userId,
                                    "page": page
                                ],
                                    responseDecodable: ChatRequestModel.self) { result in
            debugPrint("getMessageList: \(result)")
            self.messages = result.data ?? []
        } failure: { _ in
            
        }
    }
    
    func sendTextMessage(_ message: String, type: Int = 0) {
        if message.isEmpty {
            debugPrint("消息不能为空")
            return
        }
        NetworkTools.sendMessage(userId, message, type) { chat in
            self.newMessages.append(chat)
            self.textMessage = ""
            ProgressHUD.dismiss()
        }
    }


}


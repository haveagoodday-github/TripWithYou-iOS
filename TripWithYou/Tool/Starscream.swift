//
//  Starscream.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation
import Starscream
import SwiftUI
import SwiftyJSON
import Combine
import ProgressHUD


let BASE_SOCKET = "ws://192.168.31.214:8889/webSocket"


final class Socket: WebSocketDelegate, ObservableObject {
    // MARK: - Shared Instance
    static let shared = Socket()
    
    // MARK: - Private Instance Attributes
    private var webSocket: WebSocket
    private let subject = PassthroughSubject<ChatModel, Never>()
    var newMessagePublisher: AnyPublisher<ChatModel, Never> {
            subject.eraseToAnyPublisher()
        }
    
    
    // MARK: - Initializers
    private init() {
        let url = URL(string: BASE_SOCKET)!
        var urlRequest = URLRequest(url: url)
        webSocket = WebSocket(request: urlRequest)
        webSocket.delegate = self
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .text(let text):
            print("接收到的文本数据: \(text)" )
            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
                let json = try? JSON(data: dataFromString)
                
                let type = json?["type"].int ?? 0
                if type == 999 {
                    print("公告")
                    let title = json?["title"].string
                    let content = json?["content"].string
                    ProgressHUD.banner("公告", "\(title!): \(content!)")
                    return
                } else {
                    handleReceivedText(text)
                }
            }
            
        case .binary(let data):
            print("接收到数据: \(data)")
        case .cancelled:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                debugPrint("重新连接...")
                self.connect()
            })
        case .connected(_):
            if let userinfo = UserCache.shared.getUserInfo() {
                Socket.shared.write(with: "{'uid': '\(String(UserCache.shared.getUserInfo()!.userId))'}") // 上线
            }
        default:
            break
        }
    }
    private func handleReceivedText(_ text: String) {
        if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let beUserId = json?["beUserId"].int ?? 0
            if beUserId != UserCache.shared.getUserInfo()!.userId {
                return
            }
            let messageId = json?["messageId"].int ?? 0
            let userId = json?["userId"].int ?? 0
            
            let state = json?["state"].int ?? 0
            let type = json?["type"].int ?? 0
            let content = json?["content"].string ?? ""
            let createTime = json?["createTime"].string ?? ""
            let updateTime = json?["updateTime"].string ?? ""
            
            
            
            UserRequest.getUserInfoByUserId(userId) { userinfo in
                ProgressHUD.banner(userinfo.nickname, content)
            }
            
            let message = ChatModel(messageId: messageId, userId: userId, beUserId: beUserId, content: content, state: state, createTime: createTime, updateTime: updateTime, type: type)
            subject.send(message) // Publish new message
        }
        
    
    }
    
    
    
}

extension Socket {
    func connect() {
        webSocket.connect()
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
    
    func write(with string: String) {
        webSocket.write(string: string)
    }
    
}

//
//  TripViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation

class TripViewModel: ObservableObject {
    @Published var currentTabBarType: TabBarType = .subscribeStatus
    @Published var isShowTabBar: Bool = true
    @Published var tabbar: [TabbarModel] = [
        TabbarModel(name: "伴游", image: "we", selectedImage: "we-fill", type: .subscribeStatus),
        TabbarModel(name: "发布", image: "post", selectedImage: "post-fill", type: .postSubscribe),
        TabbarModel(name: "消息", image: "message", selectedImage: "message-fill", type: .message),
        TabbarModel(name: "我的", image: "me", selectedImage: "me-fill", type: .me)
    ]
    
}

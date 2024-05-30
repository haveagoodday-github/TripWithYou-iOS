//
//  AdminViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import Foundation
import ProgressHUD

class AdminViewModel: ObservableObject {
    @Published var currentTabBarType: TabBarType = .auditTrips
    @Published var isShowTabBar: Bool = true
    
    @Published var tabbar: [TabbarModel] = [
            TabbarModel(name: "管理Trip", image: "we", selectedImage: "we-fill", type: .auditTrips),
            TabbarModel(name: "管理用户", image: "order", selectedImage: "order-fill", type: .manageAdmin),
            TabbarModel(name: "公告管理", image: "message", selectedImage: "message-fill", type: .announcement),
            TabbarModel(name: "审核用户", image: "me", selectedImage: "me-fill", type: .me)
        ]
    @Published private(set) var types: [TabBarType] = [.auditTrips, .manageAdmin, .auditTriper]
    
}





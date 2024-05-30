//
//  SettingView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import SwiftUI

struct SettingView: View {
    @State private var isLogout: Bool = false
    
    // 创建一个函数来查找当前视图控制器
    private func getCurrentViewController() -> UIViewController? {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        guard var topController = keyWindow.rootViewController else {
            return nil
        }
        while let presentedController = topController.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    var body: some View {
        List() {
            Section("帐号设置") {
                Button(action: {
                    UserCache.shared.clearUserInfo()
                    UserDefaults.standard.removeObject(forKey: "Authorization")
                    isLogout.toggle()
                    Socket.shared.disconnect() // 断开Socket连接
                }, label: {
                    Text("退出登录")
                })
                
                
            }
            
            if UserCache.shared.getUserInfo()?.type == 3 {
                Section("管理员设置") {
                    NavigationLink {
                        FeedbackListView()
                    } label: {
                        Text("用户反馈列表")
                    }

                }
            }
        }
        .background {
            NavigationLink(
                destination: ContentView()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                ,
                isActive: $isLogout) {
            }
            
        }
    }
}



struct FeedbackListView: View {
    @StateObject private var viewModel: FeedbackListViewModel = FeedbackListViewModel()
    @State private var isGo: Bool = false
    var body: some View {
        List(viewModel.fList, id: \.feedbackId) { f in
            HStack(alignment: .center, spacing: 0)  {
                VStack(alignment: .leading, spacing: 4)  {
                    HStack(alignment: .center, spacing: 0)  {
                        Text("投诉类型: ")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .regular))
                        Text(f.type)
                    }
                    
                    VStack(alignment: .leading, spacing: 4)  {
                        Text("投诉内容: ")
                            .foregroundColor(.gray)
                            .font(.system(size: 12, weight: .regular))
                        Text(f.content)
                    }
                }
                Spacer()
            }
            .backgroundNavigation(to: SubscribeDetails(tripId: f.tripId, viewModel: SubscribeViewModel(), isEnd: false), isGo: $isGo)
            
        }
    }
}


class FeedbackListViewModel: ObservableObject {
    @Published private(set) var fList: [FeedbackListModel] = []
    
    init() {
        getFeedbackList()
    }
    
    private func getFeedbackList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/user/getFeedbackList",
                                method: .get,
                                parameters: ["page": page],
                                responseDecodable: FeedbackListRequestModel.self) {[self] result in
            print(result)
            if let data = result.data {
                fList = data
            }
        } failure: { _ in
            
        }
    }
    
}

struct FeedbackListRequestModel: Decodable {
    let code: Int
    let message: String
    let data: [FeedbackListModel]?
}
struct FeedbackListModel: Decodable {
    let content: String
    let type: String
    let tripId: Int
    let fromUserId: Int
    let feedbackId: Int
    let state: Int
}

//
//  UserViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import Foundation
import Combine
import ProgressHUD

class UserViewModel: ObservableObject {
    @Published private(set) var tripArray: [TripModel] = []
    @Published private(set) var filterTripArray: [TripModel] = []
    @Published private(set) var tripEvaList: [EvaluateModel] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    @Published var currentTabBarType: TabBarType = .trip
    @Published var tabbar: [TabbarModel] = [
        TabbarModel(name: "伴游", image: "we", selectedImage: "we-fill", type: .trip),
        TabbarModel(name: "订单", image: "order", selectedImage: "order-fill", type: .order),
        TabbarModel(name: "消息", image: "message", selectedImage: "message-fill", type: .message),
        TabbarModel(name: "我的", image: "me", selectedImage: "me-fill", type: .me)
    ]
    @Published var isShowTabBar: Bool = true
    @Published var showPaySheetView: Bool = false
    
    init() {
        getTripArray()
        addSubscribers()
    }
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    
    // 预约
    func subscribeAction(tripId: Int) {
        NetworkTools.requestAPI(convertible: "/trip/subscribe",
                                method: .post,
                                parameters: ["tripId": tripId],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                ProgressHUD.succeed("预约成功")
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { _ in
            
        }

    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String) {
        guard !searchText.isEmpty else {
            filterTripArray = []
            return
        }
        let search = searchText.lowercased()
        filterTripArray = tripArray.filter({ restaurant in
            let nameContainsSearch = restaurant.title.lowercased().contains(search)
            let backgroundContainsSearch = restaurant.background.lowercased().contains(search)
            return nameContainsSearch || backgroundContainsSearch
        })
    }
    
    func getTripArray() {
        NetworkTools.requestAPI(convertible: "/trip/getTrips",
                                method: .get,
                                responseDecodable: TripRequestModel.self)
        { result in
            self.tripArray = result.data
        } failure: { error in
            
        }
    }
    
    
    
    
    
    func getTripEvaList(trip_id: Int) {
        ProgressHUD.animate("加载评论中...")
        NetworkTools.requestAPI(convertible: "/trip/getEvaluates",
                                method: .post,
                                parameters: ["trip_id": trip_id],
                                responseDecodable: EvaluateRequestModel.self
        ) { result in
            print("getEvaluates: \(result)")
            if result.code == 0 {
                self.tripEvaList = result.data
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { error in
            ProgressHUD.error("加载评论失败")
        }

    }
    
    func pay(tripId: Int) {
        ProgressHUD.animate("拉起支付页面", .ballVerticalBounce, interaction: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.showPaySheetView.toggle()
            ProgressHUD.dismiss()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            ProgressHUD.banner("微信支付", "支付成功", delay: 3)
            self.subscribeAction(tripId: tripId)
        })
    }
    
}



func daysBetween(starttime: String, endtime: String) -> Int? {
    // 创建一个日期格式化器
    let formatter = DateFormatter()
    // 设置日期格式
    formatter.dateFormat = "yy-MM-dd"
    
    // 使用格式化器将字符串转换为日期
    guard let start = formatter.date(from: starttime),
          let end = formatter.date(from: endtime) else {
        // 如果转换失败，返回nil
        return nil
    }
    
    // 使用Calendar计算两个日期之间的天数差
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: start, to: end)
    
    // 返回间隔天数
    return components.day
}

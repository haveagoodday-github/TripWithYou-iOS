//
//  SubscribeViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

// 0预约中 1预约通过 2用户取消预约 3导游取消预约 4预约完成
import Foundation
import ProgressHUD
import Combine
import SwiftUI


class SubscribeViewModel: ObservableObject {
    @Published var subscribeArray: [SubscribeModel] = []
    @Published var filterTripArray: [SubscribeModel] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published private(set) var tripEvaList: [EvaluateModel] = []
    @Published var trip: TripModel = TripModel(tripId: 0, triperId: 0, userId: 0, title: "", background: "", tripCreateTime: "", tripUpdateTime: "", triperName: "", language1: "", language2: "", language3: "", username: "", nickname: "", avatar: "", sex: 0, birthday: "", averageScore: 0, reviewCount: 0, serviceTitle: "", serviceContent: "", serviceTitle2: "", serviceContent2: "", serviceTitle3: "", serviceContent3: "", tripStartTime: "", tripEndTime: "", price: "0", images: "")
    @Published var isHiddenMe: Bool = false
    @Published var inputEvaText: String = ""
    @Published var isScore: Bool = false
    
    init() {
        getSubscribe()
        addSubscribers()
    }
    
    var isSearching: Bool {
        !searchText.isEmpty
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
        filterTripArray = subscribeArray.filter({ restaurant in
            let titleContainsSearch = restaurant.title.lowercased().contains(search)
            let backgroundContainsSearch = restaurant.background.lowercased().contains(search)
            return titleContainsSearch || backgroundContainsSearch
        })
    }
    
    
    func getSubscribe() {
        NetworkTools.requestAPI(convertible: "/trip/getSubscribes",
                                method: .get,
                                responseDecodable: SubscribeRequestModel.self
        ) { result in
            DispatchQueue.main.async {
                self.subscribeArray = result.data
            }
        } failure: { _ in
            
        }
    }
    
    func updateSubscribeState(subId: Int, state: Int) {
        NetworkTools.requestAPI(convertible: "/trip/updateSubscribeState",
                                method: .post,
                                parameters: ["subId": subId, "state": state],
                                responseDecodable: baseModel.self
        ) { result in
            if result.code == 0 {
                self.getSubscribe()
                if state == 2 {
                    ProgressHUD.succeed("取消预约成功")
                } else if state == 3 {
                    ProgressHUD.succeed("拒绝预约成功")
                }
            }
        } failure: { _ in
            
        }

    }
    
    func getTripByTripId(tripId: Int) {
        NetworkTools.requestAPI(convertible: "/trip/getTripByTripId",
                                method: .post,
                                parameters: [
                                    "tripId": tripId
                                ],
                                responseDecodable: SingleTripRequestModel.self)
        { result in
            print(result.data)
            self.trip = result.data
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
    
    func postEva(tripId: Int, score: Int) {
        NetworkTools.requestAPI(convertible: "/trip/postEva",
                                method: .post,
                                parameters: [
                                    "isAnonmity": isHiddenMe ? 1 : 0,
                                    "content": inputEvaText,
                                    "tripId": tripId,
                                    "score": score
                                ],
                                responseDecodable: baseModel.self
        ) { result in
            if result.code == 0 {
                self.getTripEvaList(trip_id: tripId)
                ProgressHUD.succeed(result.data)
                self.inputEvaText = ""
                self.isHiddenMe = false
            } else {
                ProgressHUD.failed("评价失败")
            }
        } failure: { _ in
            
        }

    }
    
}


final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

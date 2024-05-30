//
//  MyPostTripsViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation
import Combine
import ProgressHUD

class MyPostTripsViewModel: ObservableObject {
    @Published var myPostTripsArray: [MyPostTripsModel] = []
    @Published var filterMyPostTripsArray: [MyPostTripsModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var subUserInfoList: [SubscribesUserInfoModel] = []
    @Published var isShowUserInfoListSheet: Bool = false
    @Published var currentTrip: TripModel = .empty
    @Published private(set) var tripEvaList: [EvaluateModel] = []
    @Published var pickerSelectArray: [String] = ["全部", "待审核", "已接受", "已取消", "已拒绝", "已完结"]
    @Published var pickerSelected: String = "全部"
    
    init() {
        getMyPostTrips()
        addSubscribers()
    }
    
    func getIndex(for selected: String) -> Int {
        return pickerSelectArray.firstIndex(of: selected) ?? 0
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
            filterMyPostTripsArray = []
            return
        }
        print(searchText)
        let search = searchText.lowercased()
        filterMyPostTripsArray = myPostTripsArray.filter({ restaurant in
            let titleContainsSearch = restaurant.title.contains(search)
            let backgroundContainsSearch = restaurant.background.contains(search)
            return titleContainsSearch || backgroundContainsSearch
        })
    }
    
    func getMyPostTrips() {
        if UserCache.shared.getUserInfo()?.type == 3 {
            return
        }
        NetworkTools.requestAPI(convertible: "/trip/getMyPostTrips",
                                method: .get,
                                responseDecodable: MyPostTripsRequestModel.self) { result in
            if let data = result.data {
                DispatchQueue.main.async {
                    self.myPostTripsArray = data
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
                                responseDecodable: SingleTripRequestModel.self) { result in
            print(result)
            if result.code == 0 {
                self.currentTrip = result.data
            }
            ProgressHUD.dismiss()
        } failure: { _ in
            
        }
    }
    
    
    func getTripSubUserInfoList(tripId: Int) {
        print("-----Current TripID: \(tripId)")
        ProgressHUD.animate("获取列表中...")
        
        getTripByTripId(tripId: tripId)
        getTripEvaList(trip_id: tripId)
        
        NetworkTools.requestAPI(convertible: "/triper/getTripSubUserInfoList",
                                method: .post,
                                parameters: [
                                    "tripId": tripId
                                ],
                                responseDecodable: SubscribesUserInfoRequestModel.self) { result in
            print(result)
            if result.code == 0 {
                self.subUserInfoList = result.data
            }
            ProgressHUD.dismiss()
        } failure: { _ in
            ProgressHUD.dismiss()
            ProgressHUD.error("获取列表失败")
        }

    }
    
    func updateUserSubState(subId: Int, subState: Int) {
        NetworkTools.requestAPI(convertible: "/triper/updateUserSubState",
                                method: .post,
                                parameters: [
                                    "subId": subId,
                                    "subState": subState
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                self.modifyUserState(subId: subId, newState: subState)
            }
        } failure: { _ in
            
        }

    }
    
    
    func modifyUserState(subId: Int, newState: Int) {
        if let index = subUserInfoList.firstIndex(where: { $0.subId == subId }) {
            subUserInfoList[index].status = newState
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
    
    func ondisappear() {
        ProgressHUD.dismiss()
    }
}



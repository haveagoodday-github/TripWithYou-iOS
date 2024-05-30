//
//  NoAuditTripsViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation
import SwiftUI
import ProgressHUD

class NoAuditTripsViewModel: ObservableObject {
    @Published private(set) var noAuditTripsArray: [NoAuditTripsModel] = []
    
    init() {
        getTrips()
    }
    
    func getTrips() {
        NetworkTools.requestAPI(convertible: "/admin/getNoAuditTrips",
                                method: .get,
                                responseDecodable: NoAuditTripsRequestModel.self) { result in
            if result.code == 0 {
                self.noAuditTripsArray = result.data
                if result.data.isEmpty {
                    ProgressHUD.failed("暂无数据")
                }
            }
        } failure: { _ in
            
        }
    }
    
    func updateTripAuditStatus(tripId: Int, state: Int) {
        withAnimation(.spring) {
            self.removeTrip(by: tripId)
        }
        NetworkTools.requestAPI(convertible: "/admin/updateTripAuditStatus",
                                method: .post,
                                parameters: [
                                    "tripId": tripId,
                                    "state": state
                                ],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                withAnimation(.spring) {
                    self.removeTrip(by: tripId)
                }
                if state == 1 {
                    ProgressHUD.succeed("审核通过")
                } else {
                    ProgressHUD.error("不通过", delay: 2)
                }
            }
        } failure: { _ in
            
        }

    }
    
    func removeTrip(by tripId: Int) {
        // 使用filter方法创建一个新数组，排除掉id匹配的元素
        noAuditTripsArray = noAuditTripsArray.filter { $0.tripId != tripId }
    }
}

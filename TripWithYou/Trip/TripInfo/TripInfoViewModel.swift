//
//  TripInfoViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/20.
//

import Foundation
import SwiftUI


class TripInfoViewModel: ObservableObject {
    @Published private(set) var tripInfo: TripModel? = nil
    @Published var isOpenEditPersonelInfoFullCover: Bool = false // Normal is false
    
    @Published var name: String = ""
    @Published var nickname: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var avatar: [UIImage] = []
    @Published var sex: Int = 0
    @Published var birthday: Date = Date()
    @Published var backgrounp: String = ""
    @Published var language1: String = "普通话（中文）"
    @Published var language2: String = "无"
    @Published var language3: String = "无"
    
    
    @Published var language11: Int = 1
    @Published var language22: Int = 1
    @Published var language33: Int = 1
    
    @Published var isPicker: Bool = false
    @Published private(set) var allLanguages: [LanguageModel.data] = []
    
    // 初始化导游个人信息
    func initializeTripInfo() {
        
    }
    
    
    private func getAllLanguages() {
        NetworkTools.requestAPI(convertible: "/trip/getLanguages",
                                method: .get,
                                responseDecodable: LanguageModel.self) { result in
            print(result.data)
            self.allLanguages = result.data
        } failure: { error in
            
        }
    }
}

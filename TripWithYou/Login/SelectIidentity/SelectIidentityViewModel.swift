//
//  SelectIidentityViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import Foundation
import ProgressHUD

class SelectIidentityViewModel: ObservableObject {
    @Published var type: Int = 4
    @Published var isGoToUserView: Bool = false
    @Published var isGoToTripView: Bool = false
    @Published var isGoToAdminView: Bool = false
    
    func updateUserType() {
        NetworkTools.requestAPI(convertible: "/user/updateUserType",
                                method: .post,
                                parameters: ["type": type],
                                responseDecodable: baseModel.self) { result in
            if result.code == 0 {
                let t = self.type
                if t == 1 {
                    self.isGoToUserView.toggle()
                } else if t == 2 {
                    self.isGoToTripView.toggle()
                } else if t == 3 {
                    // Admin
                    self.isGoToAdminView.toggle()
                }
            } else {
                ProgressHUD.error(result.message)
            }
        } failure: { _ in
            
        }
    }
}

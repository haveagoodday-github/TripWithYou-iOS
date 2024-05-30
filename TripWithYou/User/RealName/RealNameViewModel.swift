//
//  RealNameViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import Foundation



final class RealNameViewModel: ObservableObject {
    @Published var isRealName: realStatus = .noSubmit
    @Published var realnameForm: RealNameModel = .empty
    @Published var disable: Bool = false
    
    init() {
        initFun()
    }
    
    func initFun() {
        UserRequest.getUserInfoByUserId {[self] userinfo in
            handleRealStatus(userinfo.realStatus)
            if let realname = userinfo.realname, let realId = userinfo.identificationCard {
                realnameForm.realname = realname
                realnameForm.realId = realId
                disable = true
            }
        }
    }
    
    private func handleRealStatus(_ rs: Int?) {
        if let realStatus = rs {
            switch realStatus {
            case 1:
                isRealName = .pass
            case 2:
                isRealName = .waitVer
            default:
                isRealName = .verFailed
            }
        } else {
            isRealName = .noSubmit
        }
        debugPrint(isRealName.rawValue)
    }
    
    func submitIdentity(completion: @escaping (Bool) -> Void) {
        debugPrint(realnameForm.realname)
        debugPrint(realnameForm.realId)
        NetworkTools.requestAPI(convertible: "/user/submitIdentity",
                                method: .post,
                                parameters: [
                                    "realname": realnameForm.realname,
                                    "identificationCard": realnameForm.realId
                                ],
                                responseDecodable: baseModel.self) {[self] result in
            debugPrint("submitIdentity: \(result)")
            completion(result.code == 0)
            realnameForm = .empty
        } failure: { _ in
            completion(false)
        }
    }
    
}

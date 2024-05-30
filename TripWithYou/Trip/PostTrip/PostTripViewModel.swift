//
//  PostTripViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import Foundation
import ProgressHUD
import UIKit

class PostTripViewModel: ObservableObject {
    @Published var tripForm: PostTripModel = .empty
    @Published var images: [UIImage] = []
    @Published var picker: Bool = false
    
    
    init() {
        
    }
    

    
    func postTrip() {
        NetworkTools.requestAPI(convertible: "/user/getTriperInfo",
                                method: .get,
                                responseDecodable: TriperRequestModel.self) { result in
            debugPrint("getTriperInfo: \(result)")
            if result.code == 0 {
                self.postTripAction(triperId: result.data.id)
            }
        } failure: { _ in
            
        }
    }
    
    func postTripAction(triperId: Int) {
        if !validateTripForm() {
            return
        }
            
        FileUpdateManager.updateImages(images) { imagesUrl in
            debugPrint("imagesUrl: \(imagesUrl.joined(separator: ", "))")
            let tripForm = self.tripForm
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            NetworkTools.requestAPI(convertible: "/trip/postTrip",
                                    method: .post,
                                    parameters: [
                                        "triperId": triperId,
                                        "title": tripForm.title,
                                        "background": tripForm.background,
                                        "serviceTitle": tripForm.serviceTitle,
                                        "serviceContent": tripForm.serviceContent,
                                        "serviceTitle2": tripForm.serviceTitle2,
                                        "serviceContent2": tripForm.serviceContent2,
                                        "serviceTitle3": tripForm.serviceTitle3,
                                        "serviceContent3": tripForm.serviceContent3,
                                        "tripStartTime": formatter.string(from: tripForm.tripStartTime),
                                        "tripEndTime": formatter.string(from: tripForm.tripEndTime),
                                        "price": tripForm.price,
                                        "images": imagesUrl.joined(separator: ", "),
                                    ],
                                    responseDecodable: baseModel.self) { result in
                if result.code == 0 {
                    ProgressHUD.succeed(result.message)
                } else {
                    ProgressHUD.error(result.message)
                }
                self.tripForm = .empty
                self.images = []
                print(result.message)
            } failure: { _ in
                
            }
        }
        
        
    }
    
    func validateTripForm() -> Bool {
        if tripForm.title.isEmpty {
            ProgressHUD.error("标题不能为空")
            return false
        }
        
        if tripForm.background.isEmpty {
            ProgressHUD.error("背景信息不能为空")
            return false
        }
        
        if tripForm.background.count > 1000 {
            ProgressHUD.error("背景信息不能超过1000个字符")
            return false
        }
        
        if tripForm.serviceTitle.isEmpty {
            ProgressHUD.error("服务标题不能为空")
            return false
        }
        
        if tripForm.serviceContent.isEmpty {
            ProgressHUD.error("服务内容不能为空")
            return false
        }
        
        if images.isEmpty {
            ProgressHUD.error("至少上传一张图片")
            return false
        }
        
        return true
    }
}






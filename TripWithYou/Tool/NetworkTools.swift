//
//  NetworkTools.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import Foundation
import Alamofire
import ProgressHUD
import SwiftUI
import SwiftyJSON
import ExyteMediaPicker
import UIKit

let BASE_LOCALHOST_URL: String = "http://192.168.31.214:8081"

class NetworkTools {
    private class func getHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders()
        if let token = UserDefaults.standard.string(forKey: "Authorization") {
            headers.add(HTTPHeader.authorization(token))
        }
        return headers
    }
    
    class func requestAPI<T: Decodable>(convertible: URLConvertible,
                           method: HTTPMethod = .get,
                           parameters: Parameters? = nil,
//                           headers: HTTPHeaders? = nil,
                                         responseDecodable: T.Type,
                                         success: @escaping (T) -> Void,
                                         failure: @escaping (String) -> Void) {
        let url = "\(BASE_LOCALHOST_URL)\(convertible)"
        AF.request(url, method: method, parameters: parameters, headers: getHeaders())
            .responseDecodable(of: responseDecodable) { res in
            switch res.result {
            case .success(let result):
                success(result)
            case .failure(let error):
                failure(error.localizedDescription)
                debugPrint("\(convertible) result error: \(error.localizedDescription)")
                debugPrint(parameters)
                ProgressHUD.error("网络异常! ErrorCode:\(convertible)")
            }
        }

    }
    
    class func uploadImage(image: UIImage, completion: @escaping (String) -> Void) {
        ProgressHUD.animate("上传中...")
        let defAvatarUrl = "https://voicechat.oss-cn-shenzhen.aliyuncs.com/logo.jpg"
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "file",
                                     fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
        },
                  to: "\(BASE_LOCALHOST_URL)/upload",
                  method: .post,
                  headers: getHeaders()
        ).responseDecodable(of: baseModel.self) { response in
            ProgressHUD.dismiss()
            switch response.result {
            case .success(let result):
                completion(result.data ?? defAvatarUrl)
            case .failure(_):
                completion(defAvatarUrl)
            }
        }
    }
    
    class func uploadFile(file: Media, completion: @escaping (String) -> Void) async {
        await ProgressHUD.animate("上传中...")
        let defVideoUrl = "https://voicechat.oss-cn-shenzhen.aliyuncs.com/logo.jpg"
        var mimeType = "image/jpeg"
        var fileExtension = "jpg"
        if file.type == .video {
            mimeType = "video/mp4"
            fileExtension = "mp4"
        }
        if let data = await file.getData() {
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(data,
                                         withName: "file",
                                         fileName: "\(UUID().uuidString).\(fileExtension)", mimeType: mimeType)
            },
                      to: "\(BASE_LOCALHOST_URL)/upload",
                      method: .post,
                      headers: getHeaders()
            ).responseDecodable(of: baseModel.self) { response in
                switch response.result {
                case .success(let result):
                    completion(result.data ?? defVideoUrl)
                case .failure(_):
                    completion(defVideoUrl)
                }
            }
        }
    }

    
    class func sendMessage(_ beUserId: Int, _ message: String, _ type: Int = 0, completion: @escaping (ChatModel) -> Void) {
        let current_time = Timer.getCurrentTimeString()

        let dict = ChatModel(messageId: Int.random(in: 100000...999999),
                             userId: UserCache.shared.getUserInfo()!.userId, beUserId: beUserId, content: message, state: 0, createTime: current_time, updateTime: current_time, type: type)
        
        do {
            let jsonData = try JSONEncoder().encode(dict)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                AF.request("\(BASE_LOCALHOST_URL)/push/\(String(beUserId))",
                           method: .get,
                           parameters: ["message": jsonString],
                           headers: getHeaders()).response { response in
                    if response.response?.statusCode == 200 {
                        print("发送成功")
                        completion(dict)
                    } else {
                        ProgressHUD.error("发送失败")
                        completion(dict)
                    }
                }
                
                
            }
        } catch {
            print("Error encoding ChatModel: \(error)")
        }
        
        
    }
    
    class func pushAll(title: String, content: String, completion: @escaping (Bool) -> Void) {
        
        struct MyData: Encodable {
            let title: String
            let content: String
            let type: Int
        }
        
        let dict = MyData(title: title, content: content, type: 999)
        
        do {
            let jsonData = try JSONEncoder().encode(dict)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                AF.request("\(BASE_LOCALHOST_URL)/push/pushAll", // TODO: 补充链接
                           method: .get,
                           parameters: ["message": jsonString],
                           headers: getHeaders()).response { response in
                    if response.response?.statusCode == 200 {
                        print("推送成功")
                        completion(true)
                    } else {
                        ProgressHUD.error("推送失败")
                        completion(false)
                    }
                }
            }
        } catch {
            print("Error encoding ChatModel: \(error)")
        }
    }
    
    
    class func fetchCaptcha(completion: @escaping (UIImage?, String?) -> Void) {
        AF.request("\(BASE_LOCALHOST_URL)/graphicVerificationCode/getVerifyThree", method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                let json = try? JSON(data: data)
                let captchaKey = json?["captchaKey"].string
                let captchaImg = json?["captchaImg"].string
                
                if let image = base64ToImage(captchaImg!) {
                    completion(image, captchaKey)
                }
            case .failure(let error):
                print("Error fetching captcha: \(error)")
                completion(nil, nil)
            }
        }
        
        func base64ToImage(_ base64String: String) -> UIImage? {
            let cleanedBase64String = base64String.replacingOccurrences(of: "data:image/png;base64,", with: "")
            
            guard let data = Data(base64Encoded: cleanedBase64String, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return UIImage(data: data)
        }
    }
    
    
    class func checkCaptcha(captchaKey: String, captchaCode: String, completion: @escaping (Bool) -> Void) {
        let url = "\(BASE_LOCALHOST_URL)/graphicVerificationCode/checkCaptchaTwo"
        let parameters: Parameters = [
            "captchaCode": captchaCode,
            "CaptchaKey": captchaKey
        ]
        AF.request(url, method: .get, parameters: parameters, headers: getHeaders()).response { response in
            switch response.result {
            case .success(let data):
                if let data = data, let isValid = try? JSONDecoder().decode(Bool.self, from: data) {
                    completion(isValid)
                } else {
                    completion(false)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(false)
            }
        }
    }
    
}



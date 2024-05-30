//
//  FeedbackModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import Foundation


enum FeedbackType: String, CaseIterable {
    case badAttitude = "态度恶劣" // 态度恶劣
    case overcharge = "多收费" // 多收费
    case unprofessional = "不专业" // 不专业
    case lateArrival = "到达迟到" // 到达迟到
    case safetyConcern = "安全问题" // 安全问题
    case inappropriateBehavior = "不当行为" // 不当行为
    case poorCommunication = "沟通不畅" // 沟通不畅
    case misleadingInformation = "误导信息" // 误导信息
    case refusalToProvideService = "拒绝提供服务" // 拒绝提供服务
    case poorHygiene = "卫生差" // 卫生差
    case rudeLanguage = "言语粗鲁" // 言语粗鲁
    case notAsDescribed = "与描述不符" // 与描述不符
    case other = "其他" // 其他
}

struct feedbackFormModel {
    var tripId: Int
    var content: String
    var type: FeedbackType
    
    static let empty = feedbackFormModel(tripId: 0, content: "", type: .other)
}

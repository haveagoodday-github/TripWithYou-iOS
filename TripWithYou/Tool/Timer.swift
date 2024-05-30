//
//  Timer.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation

class Timer {
    /// 时间格式T
    /// - Parameters:
    ///   - timeString: yyyy-MM-dd'T'HH:mm:ss
    ///   - defaultReturn: 默认返回值，暂无人订阅
    /// - Returns: x分钟前/x周前/x月前...
    class func formatRelativeTime(from timeString: String, _ defaultReturn: String = "暂无人订阅") -> String {
        // 将时间字符串转换为Date对象
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 使用POSIX以避免时区问题
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        // 使用RelativeDateTimeFormatter来格式化日期为相对时间
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .full // 使用完整单位样式
        relativeFormatter.locale = Locale(identifier: "zh-Hans") // 设置为简体中文
        
        // 解析时间字符串并计算相对时间
        if let date = dateFormatter.date(from: timeString) {
            let relativeTime = relativeFormatter.localizedString(for: date, relativeTo: Date())
            return "\(relativeTime)"
        } else {
            // 如果时间字符串无法解析，返回nil
            return defaultReturn
        }
    }
    
    
    /// 获取当前时间字符串
    /// - Returns: "yyyy-MM-dd'T'HH:mm:ss"
    class func getCurrentTimeString() -> String {
        // 获取当前日期和时间
        let currentDate = Date()
        
        // 创建日期格式化器
        let dateFormatter = DateFormatter()
        
        // 设置日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // 将日期转换为字符串
        let dateString = dateFormatter.string(from: currentDate)
        
        return dateString
    }

}

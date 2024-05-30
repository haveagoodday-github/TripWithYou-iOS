//
//  ProgressHUDView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import ProgressHUD

final class ProgressHUDView {
    class func error(_ text: String, _ delay: Double = 2) {
        ProgressHUD.error(text, delay: delay)
    }
    
    class func success(_ text: String, _ delay: Double = 1.5) {
        ProgressHUD.succeed(text, delay: delay)
    }
    
    class func failed(_ text: String, _ delay: Double = 2) {
        ProgressHUD.failed(text, delay: delay)
    }
    class func dismiss() {
        ProgressHUD.dismiss()
    }
}

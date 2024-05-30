//
//  FileUpdateManager.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation
import ProgressHUD
import UIKit

class FileUpdateManager {
    class func updateImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        var update: CGFloat = 0
        ProgressHUD.progress("上传图片中...", update)
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "uploadImage")
        var updatedImages: [String] = []
        
        for (_, image) in images.enumerated() {
            group.enter()  // 进入组，表示开始一个任务
            queue.async {
                NetworkTools.uploadImage(image: image) { url in
                    update += CGFloat(1.0 / CGFloat(images.count))
                    ProgressHUD.progress("上传图片中...", update)
                    updatedImages.append(url)  // 保存上传结果
                    group.leave()  // 任务完成，离开组
                }
            }
        }
        
        group.notify(queue: queue) { // 当所有任务完成时执行
            DispatchQueue.main.async {
                ProgressHUD.succeed("上传图片完成")
                
                // 清理并更新状态
                let cleanUrls = updatedImages.compactMap { $0 }
                let finalUrls = cleanUrls.map { url in
                    return url.components(separatedBy: "/").last ?? ""
                }
                
                // 将结果传递给 completion 闭包
                completion(finalUrls)
            }
        }
    }
}

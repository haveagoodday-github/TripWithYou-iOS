//
//  KFImageView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI
import Kingfisher


enum ImageScaleMode {
    case fit
    case fill
}

struct KFImageView: View {
    var imageUrl: String
    var scaleMode: ImageScaleMode = .fit
    
    init(_ imageUrl: String,_ scaleMode: ImageScaleMode = .fit) {
        self.imageUrl = imageUrl
        self.scaleMode = scaleMode
    }

    var completeImageUrl: String {
        if imageUrl.starts(with: "https://") {
            return imageUrl
        } else {
            return "https://voicechat.oss-cn-shenzhen.aliyuncs.com/" + imageUrl
        }
    }

    var body: some View {
        KFImage(URL(string: completeImageUrl))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.5)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .applyScaleMode(scaleMode)
    }
}

extension View {
    func applyScaleMode(_ scaleMode: ImageScaleMode) -> some View {
        switch scaleMode {
        case .fit:
            return AnyView(self.scaledToFit())
        case .fill:
            return AnyView(self.scaledToFill())
        }
    }
}



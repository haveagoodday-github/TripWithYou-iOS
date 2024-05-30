//
//  ExtensionView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation
import SwiftUI



extension View {
    func closeKeyboard() -> some View {
        modifier(keyboardExtensionModifier())
    }
    
    func selectImageSheet(images: Binding<[UIImage]>, selectionLimit: Int = 1, allowVideo: Bool = false ) -> some View {
        modifier(
            selectImageSheetViewModifier(images: images, selectionLimit: selectionLimit)
        )
    }
    
    func openChatView(viewModel: ChatViewModel) -> some View {
        modifier(
            openChatViewViewModifier(viewModel: viewModel)
        )
    }
    
    func showUserInfoSheet(userId: Int, isAction: Bool = true) -> some View {
        modifier(ShowUserInfoSheet(userId: userId, isAction: isAction))
    }
    
    
    func backgroundNavigation<Destination: View>(to destination: Destination, isGo: Binding<Bool>) -> some View {
        modifier(BackgroundNavigation(destination: destination, isGo: isGo))
    }
    
    // MARK: 视频部分无法使用，文件无法获取；FileManager.default.fileExists...=false
    /*
     func selectVideoAndImageSheet(images: Binding<[UIImage]>, video: Binding<[URL]>, selectionLimit: Int = 1, allowVideo: Bool = false ) -> some View {
         modifier(
             selectVideoSheetViewModifier(videos: video, images: images, selectionLimit: selectionLimit)
         )
     }
     func sendImageMessage() {
         FileUpdateManager.updateImages(images) { results in
             let url = String(results.first ?? "")
             self.sendTextMessage(url, type: 1)
         }
     }
     func sendVideoMessage() {
         debugPrint("Videos: \(videos)")
         NetworkTools.uploadVideo(videoURL: videos.first!) { url in
             debugPrint("Video URL: \(url)")
         }
     }
     */
    
}



struct BackgroundNavigation<Destination: View>: ViewModifier {
    let destination: Destination
    @Binding var isGo: Bool
    
    func body(content: Content) -> some View {
        content
            .background {
                NavigationLink(destination: destination, isActive: $isGo) {
                    EmptyView()
                }
            }
    }
}



//import UIKit
//
//struct pickerMedia: ViewModifier {
//    @Binding var images: [UIImage]
//    @Binding var videos: [URL]
//    
//    func body(content: Content) -> some View {
//        content
//            .onChange(of: images, perform: { newValue in
//
//                
//            })
//            .onChange(of: videos, perform: { newValue in
//
//            })
//            .selectVideoAndImageSheet(images: $images, video: $videos, selectionLimit: 1)
//    }
//}

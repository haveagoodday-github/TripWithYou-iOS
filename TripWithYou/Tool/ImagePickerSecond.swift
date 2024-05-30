//
//  ImagePickerSecond.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/20.
//

import Foundation
import PhotosUI
import SwiftUI



import Foundation
import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct ImagePickerSecond: UIViewControllerRepresentable {

    func makeCoordinator() -> Coordinator {
        return ImagePickerSecond.Coordinator(parent1: self)
    }
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    var videoURLs: Binding<[URL]>? // 可选绑定属性，用于存储视频 URL
    var selectionLimit: Int = 1
    var allowVideo: Bool = false
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = selectionLimit
        
        // Adjust the filter based on allowVideo variable
        if allowVideo {
            config.filter = .any(of: [.images, .videos])
        } else {
            config.filter = .images
        }
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // Handle any updates to the view controller if needed
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePickerSecond
        
        init(parent1: ImagePickerSecond) {
            self.parent = parent1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.picker.toggle()
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        } else if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                } else if self.parent.allowVideo && result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
                        if let url = url {
                            DispatchQueue.main.async {
                                self.parent.videoURLs?.wrappedValue.append(url) // 仅当 videoURLs 不为空时才添加视频 URL
                            }
                        } else if let error = error {
                            print("Error loading video: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Cannot be loaded")
                }
            }
        }
    }
}


//struct ImagePickerSecond: UIViewControllerRepresentable {
//
//    func makeCoordinator() -> Coordinator {
//        return ImagePickerSecond.Coordinator(parent1: self)
//    }
//    
//    @Binding var images: [UIImage]
//    @Binding var picker: Bool
//    var selectionLimit: Int = 1
//    @Binding var allowVideo: Bool
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = selectionLimit
//        
//        // Adjust the filter based on allowVideo variable
//        if allowVideo {
//            config.filter = .any(of: [.images, .videos])
//        } else {
//            config.filter = .images
//        }
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//        // Handle any updates to the view controller if needed
//    }
//    
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: ImagePickerSecond
//        
//        init(parent1: ImagePickerSecond) {
//            self.parent = parent1
//        }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.picker.toggle()
//            for result in results {
//                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                        if let image = image as? UIImage {
//                            DispatchQueue.main.async {
//                                self.parent.images.append(image)
//                            }
//                        } else if let error = error {
//                            print("Error loading image: \(error.localizedDescription)")
//                        }
//                    }
//                } else if self.parent.allowVideo && result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                    print("Video selected")
//                } else {
//                    print("Cannot be loaded")
//                }
//            }
//        }
//    }
//}


//
//  AnnouncementViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import Foundation


final class AnnouncementViewModel: ObservableObject {
    @Published var announcements: [AnnouncementModel] = []
    @Published var title: String = ""
    @Published var content: String = ""
    
    init() {
        getAnnouncements()
    }
    
    func getAnnouncements(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/admin/getAnnouncements",
                                method: .get,
                                parameters: ["page": page],
                                responseDecodable: AnnouncementRequestModel.self) { result in
            if let data = result.data {
                self.announcements = data
            }
        } failure: { _ in
            
        }
    }
    
    func addAnnouncement() {
        if title.isEmpty || content.isEmpty {
            return
        }
        pushNotification()
    }
    
    
    private func pushNotification() {
        NetworkTools.pushAll(title: title, content: content) {[self] isSuccess in
            NetworkTools.requestAPI(convertible: "/admin/newAnnouncement",
                                    method: .post,
                                    parameters: [
                                        "title": title,
                                        "content": content
                                    ],
                                    responseDecodable: baseModel.self) { result in
                getAnnouncements()
            } failure: { _ in
                
            }
        }
    }
}

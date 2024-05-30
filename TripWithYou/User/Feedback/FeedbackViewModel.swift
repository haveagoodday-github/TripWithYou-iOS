//
//  FeedbackViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import Foundation


class FeedbackViewModel: ObservableObject {
    @Published var feedbackForm: feedbackFormModel = .empty
    
    
    init(tripId: Int) {
        feedbackForm.tripId = tripId
    }
    
    
    
    func submitFeedback(completion: @escaping (Bool) -> Void) {
        NetworkTools.requestAPI(convertible: "/user/submitFeedback",
                                method: .post,
                                parameters: [
                                    "tripId": feedbackForm.tripId,
                                    "content": feedbackForm.content,
                                    "type": feedbackForm.type
                                ],
                                responseDecodable: baseModel.self) { result in
            completion(true)
        } failure: { _ in
            completion(false)
        }

    }
    
    
}

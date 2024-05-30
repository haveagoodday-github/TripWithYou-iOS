//
//  ContactViewModel.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import Foundation
import Combine

class ContactViewModel: ObservableObject {
    @Published private(set) var contactList: [ContactModel] = []
    @Published private(set) var filterContactList: [ContactModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    
    init() {
        getContactList()
        addSubscribers()
    }
    
    private func getContactList(page: Int = 1) {
        NetworkTools.requestAPI(convertible: "/user/getContactsList",
                                method: .get,
                                parameters: [
                                    "page": page
                                ],
                                responseDecodable: ContactRequestModel.self) { result in
            self.contactList = result.data
        } failure: { _ in
            
        }
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String) {
        guard !searchText.isEmpty else {
            filterContactList = []
            return
        }
        print(searchText)
        let search = searchText.lowercased()
        filterContactList = contactList.filter({ restaurant in
            let titleContainsSearch = restaurant.nickname.contains(search)
            let backgroundContainsSearch = restaurant.lastMessageContent.contains(search)
            return titleContainsSearch || backgroundContainsSearch
        })
    }
}

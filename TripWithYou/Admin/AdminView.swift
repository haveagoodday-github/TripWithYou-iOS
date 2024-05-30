//
//  AdminView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel: AdminViewModel = AdminViewModel()
    @StateObject private var manageUsersiewModel: ManageUsersViewModel = ManageUsersViewModel()
    @StateObject private var cViewModel: ContactViewModel = ContactViewModel()
    @StateObject private var aViewModel: AnnouncementViewModel = AnnouncementViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack(alignment: .center, spacing: 0)  {
                
                VStack(alignment: .center, spacing: 0)  {
                    switch viewModel.currentTabBarType {
                    case .auditTrips:
                        NoAuditTripsView()
                    case .manageAdmin:
                        ManageUsersView(viewModel: manageUsersiewModel)
                    case .announcement:
                        AnnouncementView(viewModel: aViewModel)
                    default:
                        NoAuditTripersView()
                    }
                    Spacer(minLength: 65)
                }
                .frame(maxHeight: UIScreen.main.bounds.height)
                
            }
            
            TabBarView(currentTabBarType: $viewModel.currentTabBarType, tabbar: viewModel.tabbar)
                .offset(y: viewModel.isShowTabBar ? 0 : 200)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    AdminView()
}

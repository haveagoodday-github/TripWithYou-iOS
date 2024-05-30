//
//  TripView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI

struct TripView: View {
    @StateObject private var viewModel = TripViewModel()
    @StateObject private var cViewModel: ContactViewModel = ContactViewModel()
    @StateObject private var uViewModel: UserInfoViewModel = UserInfoViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0)  {
                VStack(alignment: .center, spacing: 0)  {
                    switch viewModel.currentTabBarType {
                    case .subscribeStatus:
                        MyPostTripsView()
                    case .postSubscribe:
                        PostTripView()
                    case .message:
                        ContactView(viewModel: cViewModel)
                    default:
                        UserInfoView(viewModel: uViewModel)
                    }
                    Spacer(minLength: 65)
                }
                .frame(maxHeight: UIScreen.main.bounds.height)
                
                
            }
            
            TabBarView(currentTabBarType: $viewModel.currentTabBarType, tabbar: viewModel.tabbar)
                .offset(y: viewModel.isShowTabBar ? 0 : 200)
        }
        .edgesIgnoringSafeArea(.bottom)
//        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.currentTabBarType, perform: { newValue in
            if newValue == .me {
                UserRequest.getUserInfoByUserId { userinfo in }
            }
        })
    }
}

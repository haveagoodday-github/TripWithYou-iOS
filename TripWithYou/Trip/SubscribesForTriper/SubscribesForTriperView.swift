//
//  SubscribesForTriperView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import SwiftUI
import ProgressHUD

struct MyPostTripsView: View {
    @StateObject private var viewModel: MyPostTripsViewModel = MyPostTripsViewModel()
    var body: some View {
        List(viewModel.searchText.isEmpty ? viewModel.myPostTripsArray : viewModel.filterMyPostTripsArray, id: \.tripId) { myPostTrip in
            NavigationLink(destination: SubscribesUserInfoListView(viewModel: viewModel, tripId: myPostTrip.tripId)) {
                MyPostTripView(trip: myPostTrip, viewModel: viewModel)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: Text("搜索标题或内容..."))
        .navigationTitle("我的发布(\(viewModel.myPostTripsArray.count))")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.inset)
        .refreshable {
            viewModel.getMyPostTrips()
        }
        .background {
            
        }
    }
}


struct MyPostTripView: View {
    var trip: MyPostTripsModel
    @StateObject var viewModel: MyPostTripsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            Text("基本信息")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .medium))
            Text(trip.title)
                .font(.system(size: 15, weight: .bold))
            Text(trip.background)
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .light))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
            HStack(alignment: .center, spacing: 2)  {
                
                if trip.auditStatus == 1 || trip.auditStatus == 4 {
                    Text("预约人数:")
                        .font(.system(size: 12))
                    Text("\(trip.totalSubscriptions)")
                        .foregroundColor(.green)
                } else {
                    Text(trip.auditStatus == 0 ? "待审核" : "审核不通过")
                        .foregroundColor(trip.auditStatus == 0 ? .gray : .red.opacity(0.7))
                }
                
                Spacer()
                Text(Timer.formatRelativeTime(from: trip.lastSubscribeUpdateTime ?? ""))
                
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.gray)
            .padding(.top, 3)
        }
        
    }
}

struct SubscribesUserInfoListView: View {
    @StateObject var viewModel: MyPostTripsViewModel
    @State var tripId: Int
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center, spacing: 12)  {
                TripItemView(trip: viewModel.currentTrip, isShowMoreInfo: true)
                evaluate(reviewCount: viewModel.currentTrip.reviewCount, tripEvaList: viewModel.tripEvaList)
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .onDisappear {
            viewModel.ondisappear()
        }
        .navigationTitle(viewModel.currentTrip.title)
        .onAppear {
            viewModel.getTripSubUserInfoList(tripId: tripId)
        }
        .navigationBarItems(trailing: trailingView)
        .sheet(isPresented: $viewModel.isShowUserInfoListSheet) {
            subList
        }
    }
    
    
    var trailingView: some View {
        Button {
            if UserCache.shared.getUserInfo()?.type != 3 {
                viewModel.isShowUserInfoListSheet.toggle()
            }
        } label: {
            Text(UserCache.shared.getUserInfo()?.type != 3 ? "查看预约" : "")
        }
    }
    
    var subList: some View {
        
        VStack(alignment: .leading, spacing: 12)  {
            
            HStack(alignment: .center, spacing: 4)  {
                Text("筛选审核状态:")
                Picker(selection: $viewModel.pickerSelected) {
                    ForEach(viewModel.pickerSelectArray, id: \.self) { type in
                        Text(type)
                    }
                } label: {
                }
                .pickerStyle(.menu)
            }
            .padding(.leading, 12)
            
            
            List(
                viewModel.getIndex(for: viewModel.pickerSelected) == 0 ? viewModel.subUserInfoList : viewModel.subUserInfoList.filter({ $0.status == viewModel.getIndex(for: viewModel.pickerSelected)-1 }), id: \.subId
            ) { user in
                
                SubscribesUserInfoItemView(user: user, viewModel: viewModel)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if user.status == 0 {
                            Button {
                                viewModel.updateUserSubState(subId: user.subId, subState: 3)
                            } label: {
                                Label("拒绝预约", systemImage: "person.badge.minus")
                            }
                            .tint(.red)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        if user.status == 0 {
                            Button {
                                viewModel.updateUserSubState(subId: user.subId, subState: 1)
                            } label: {
                                Label("接受预约", systemImage: "person.badge.plus")
                            }
                            .tint(.green)
                        }
                    }
                    .environmentObject(viewModel)
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top, 12)
    }
    
    
}





struct SubscribesUserInfoItemView: View {
    var user: SubscribesUserInfoModel
    @StateObject var viewModel: MyPostTripsViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 4)  {
            KFImageView(user.avatar, .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .showUserInfoSheet(userId: user.userId)
            
            Text(user.nickname)
            
            
            Spacer()
            Text(statusToString())
                .foregroundColor(statusToColor())
                .font(.system(size: 15, weight: .bold))
        }
    }
    
    private func statusToString() -> String {
        switch user.status {
        case 1:
            "已接受预约"
        case 2:
            "已拒绝预约"
        case 3:
            "用户预约已取消"
        case 4:
            "用户已完结订单"
        default:
            ""
        }
    }
    private func statusToColor() -> Color {
        switch user.status {
        case 1:
                .gray
        case 2:
                .red
        case 3:
                .red
        case 4:
                .green
        default:
                .pink
        }
    }
}

#Preview {
    MyPostTripsView()
}




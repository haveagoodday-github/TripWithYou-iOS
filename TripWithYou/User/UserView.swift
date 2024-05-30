//
//  UserView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

// Color(red: 0.982, green: 0.982, blue: 0.997)

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel: UserViewModel = UserViewModel()
    @StateObject private var cViewModel: ContactViewModel = ContactViewModel()
    @StateObject private var rViewModel: RealNameViewModel = RealNameViewModel()
    @StateObject private var uViewModel: UserInfoViewModel = UserInfoViewModel()
    @State private var isGoToRealNameView: Bool = false
    @State private var isOpenAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0)  {
                VStack(alignment: .center, spacing: 0)  {
                    switch viewModel.currentTabBarType {
                    case .order:
                        SubscribeView()
                    case .trip:
                        TripListView
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
        .navigationBarBackButtonHidden(true)
        
    }
    

}

extension UserView {
    var TripListView: some View {
        List(viewModel.isSearching ? viewModel.filterTripArray : viewModel.tripArray, id: \.tripId) { trip in
            NavigationLink(
                destination: TripItemDetailsView(trip: trip, viewModel: viewModel) {
                    // 预约按钮
                    subscribeAction(tripId: trip.tripId)
                }
            ) {
                TripItemView(trip: trip)
                    .padding(.horizontal, 12)
            }
        }
        .background(.white)
        .listStyle(.inset)
        .searchable(text: $viewModel.searchText, prompt: Text("搜索"))
        .refreshable {
            viewModel.getTripArray()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("伴游列表(\(viewModel.tripArray.count))")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $isOpenAlert) {
            alertAction()
        }
        .backgroundNavigation(to: RealNameView(viewModel: rViewModel), isGo: $isGoToRealNameView)
    }
    
    
    private func subscribeAction(tripId: Int) {
        if rViewModel.isRealName != .pass {
            // 弹出实名对话框
            isOpenAlert.toggle()
        } else {
            viewModel.pay(tripId: tripId)
        }
    }
    
    private func alertAction() -> Alert {
        Alert(title: Text("警告"),
              message: Text("您还没有完成实名，无法预约伴游"),
              primaryButton: .default(Text("去实名"), action: {
            isGoToRealNameView.toggle()
        }),
              secondaryButton: .cancel())
    }
}

struct TripItemView: View {
    var trip: TripModel
    @State var isShowMoreInfo: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            HStack(alignment: .center, spacing: 12)  {
                KFImageView(trip.avatar, .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)
                    .clipped()
                    .showUserInfoSheet(userId: trip.userId, isAction: isShowMoreInfo)
                
                VStack(alignment: .leading, spacing: 4)  {
                    HStack(alignment: .center, spacing: 6)  {
                        Text(trip.nickname)
                            .foregroundColor(.black)
//                            .font(.system(size: 18, weight: .bold))
                            .bold()
                            .lineLimit(1)
                        Image(trip.sex == 1 ? .boy : .gril)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                        Text(calculateAge(birthDateString: trip.birthday) + "岁")
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center, spacing: 2)  {
                        Text(trip.language1)
                        if let language = trip.language2 {
                            Text(language)
                        }
                        if let language = trip.language3 {
                            Text(language)
                        }
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .bold))
                }
                Spacer()
                VStack(alignment: .center, spacing: 0)  {
                    HStack(alignment: .center, spacing: 0)  {
                        ForEach(0..<Int(round(trip.averageScore))) { score in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        ForEach(0..<5 - Int(round(trip.averageScore))) { star in
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                    }
                    .font(.system(size: 14))
                    
                    HStack(alignment: .bottom, spacing: 2)  {
                        Text("¥")
                            .font(.system(size: 14, weight: .bold))
                        Text("\(trip.price)")
                            .italic()
                            .underline()
                    }
                    .font(.system(size: 18, weight: .bold))
                    
                }
            }
            Text(trip.background)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .lineLimit(isShowMoreInfo ? nil : 3)
            VStack(alignment: .center, spacing: 2)  {
                TripServiceItemView(title: trip.serviceTitle, content: trip.serviceContent, isShowMoreInfo: isShowMoreInfo)
                TripServiceItemView(title: trip.serviceTitle2, content: trip.serviceContent2, isShowMoreInfo: isShowMoreInfo)
                TripServiceItemView(title: trip.serviceTitle3, content: trip.serviceContent3, isShowMoreInfo: isShowMoreInfo)
            }
            
            HStack(alignment: .center, spacing: 0)  {
                if let startT = trip.tripStartTime, let endT = trip.tripEndTime, let gap = daysBetween(starttime: startT, endtime: endT)  {
                    Text(startT)
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                    Text("---")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("共\(gap)天")
                        .font(.system(size: 14, weight: .bold))
                    Spacer()
                    Text("---")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(endT)
                        .font(.system(size: 12, weight: .medium))
                }
            }
            
            if let images = trip.images {
                DynamicImagesView(dynamicImages: images.replacingOccurrences(of: " ", with: "").components(separatedBy: ","))
            }
            
        }
    }
}




struct TripServiceItemView: View {
    var title: String?
    var content: String?
    @State var isShowMoreInfo: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: isShowMoreInfo ? 4 : 2)  {
            if let t = title, let c = content {
                HStack(alignment: .center, spacing: 4)  {
                    Circle()
                        .fill(.gray)
                        .frame(width: 5, height: 5)
                    Text(t)
                        .font(.system(size: isShowMoreInfo ? 16 : 14, weight: .medium))
                    Spacer()
                }
                if isShowMoreInfo {
                    Text(c)
                        .font(.system(size: isShowMoreInfo ? 14 : 12, weight: .light))
                }
            }
        }
    }
}




struct TripItemDetailsView: View {
    @State var trip: TripModel
    @StateObject var viewModel: UserViewModel
    let subscribeAction: () -> ()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24)  {
                TripItemView(trip: trip, isShowMoreInfo: true)
                evaluate(reviewCount: trip.reviewCount, tripEvaList: viewModel.tripEvaList)
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 12)
        }
        .onAppear {
            viewModel.getTripEvaList(trip_id: trip.tripId)
        }
        .navigationTitle(trip.nickname)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: subscribe)
        .sheet(isPresented: $viewModel.showPaySheetView) {
            wechatPay
        }
    }
    
    
    var wechatPay: some View {
        VStack(alignment: .center, spacing: 12)  {
            Spacer()
            Image(.wechatPay)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            Text("支付成功")
                .font(.system(size: 20, weight: .bold))
            Text(trip.price)
                .font(.system(size: 24, weight: .bold))
            
            Button {
                viewModel.showPaySheetView.toggle()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("完成")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 12)

            Spacer()
        }
    }
    
    var subscribe: some View {
        Button {
            subscribeAction()
        } label: {
            Text("预约")
        }
    }
    
    
}

struct evaluate: View {
    @State var reviewCount: Int
    @State var tripEvaList: [EvaluateModel]
    var body: some View {
        VStack(alignment: .center, spacing: 4)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("用户评价(\(reviewCount))")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 12)
            
            if reviewCount == 0 {
                VStack(alignment: .center, spacing: 0)  {
                    Image(.noEva)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.4)
                    Text("还没有人评论")
                        .foregroundColor(.gray)
                }
            } else {
                ForEach(tripEvaList, id: \.evaluateId) { eva in
                    evaluateItem(eva: eva)
                    Divider()
                }
                .onAppear {
                    
                }
            }
        }
    }
}

struct evaluateItem: View {
    @State var eva: EvaluateModel
    var body: some View {
        VStack(alignment: .leading, spacing: 6)  {
            HStack(alignment: .center, spacing: 4)  {
                if eva.isAnonmity == 1 {
                    Image(systemName: "person")
                        .frame(width: 40, height: 40)
                        .background(Color.gray)
                        .clipShape(.circle)
                    Text("匿名用户")
                        .foregroundColor(.gray)
                } else {
                    KFImageView(eva.avatar, .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                    Text(eva.nickname)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Text(eva.content)
        }
    }
}

#Preview {
    UserView()
}


func calculateAge(birthDateString: String?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let birthDate = dateFormatter.date(from: birthDateString ?? "") else {
        return "0"
    }
    
    // 计算当前日期
    let now = Date()
    // 使用当前日历获取年份之间的差异
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
    // 提取年龄
    let age = ageComponents.year ?? 0
    
    // 返回年龄的字符串表示
    return String(age)
}

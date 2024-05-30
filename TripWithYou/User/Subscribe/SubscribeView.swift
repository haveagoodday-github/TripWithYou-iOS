//
//  SubscribeView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

import SwiftUI
import ProgressHUD

struct SubscribeView: View {
    @StateObject private var viewModel = SubscribeViewModel()
    var body: some View {
        List(viewModel.searchText.isEmpty ? viewModel.subscribeArray : viewModel.filterTripArray, id: \.subId) { subscribe in
            SubscribeItemView(subscribe: subscribe)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if subscribe.status == 0 {
                        Button {
                            viewModel.updateSubscribeState(subId: subscribe.subId, state: 2)
                        } label: {
                            Label("取消预约", systemImage: "xmark.seal")
                        }
                        .tint(.red)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if subscribe.status == 1 {
                        Button {
                            viewModel.updateSubscribeState(subId: subscribe.subId, state: 4)
                        } label: {
                            Label("结束订单", systemImage: "checkmark.seal")
                        }
                        .tint(.green)
                    }
                }
                .background {
                    NavigationLink(destination: SubscribeDetails(tripId: subscribe.tripId, viewModel: viewModel, isEnd: subscribe.status == 4)) {
                    }
                }
            
        }
        .searchable(text: $viewModel.searchText, prompt: Text("根据标题或者内容搜索"))
        .environmentObject(viewModel)
        .navigationTitle("订单")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.inset)
        .refreshable {
            viewModel.getSubscribe()
        }
    }
}

struct SubscribeItemTextView: View {
    let state: String
    let color: Color?
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("预约状态：")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .bold))
                Text(state)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
        }
    }
}

struct SubscribeItemView: View {
    @State var subscribe: SubscribeModel
    @EnvironmentObject var viewModel: SubscribeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            VStack(alignment: .leading, spacing: 3)  {
                Text(subscribe.title)
                    .font(.system(size: 16, weight: .bold))
                Text(subscribe.background)
                    .font(.system(size: 14, weight: .light))
            }
            
            VStack(alignment: .center, spacing: 0)  {
                switch subscribe.status {
                case 0:
                    SubscribeItemTextView(state: "预约成功", color: .black)
                case 1:
                    SubscribeItemTextView(state: "预约通过", color: .green)
                case 2:
                    SubscribeItemTextView(state: "预约已取消", color: .black)
                    
                case 3:
                    SubscribeItemTextView(state: "预约被拒绝", color: .red)
                case 4:
                    SubscribeItemTextView(state: "预约结束", color: .blue)
                default:
                    SubscribeItemTextView(state: "预约失败", color: .red)
                    
                }
                HStack(alignment: .center, spacing: 0)  {
                    Text("订单编号：")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .bold))
                    Text(String(subscribe.subId))
                        .font(.system(size: 12, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.gray)
            }
        }
        .foregroundColor(subscribe.status == 2 ? .gray : .black)
    }
}


struct SubscribeDetails: View {
    @State var tripId: Int
    @StateObject var viewModel: SubscribeViewModel
    @State var isEnd: Bool
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .center, spacing: 24)  {
                    TripItemView(trip: viewModel.trip, isShowMoreInfo: true)
                    evaluate()
                    Spacer(minLength: 45)
                }
                .padding(.horizontal, 12)
                
                
            }
            
            
            if isEnd {
                inputEvaView
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: FeedbackView(viewModel: FeedbackViewModel(tripId: tripId))) {
                    Text("投诉")
                        .foregroundColor(.red)
                }
            }
        })
        
        .onAppear {
            viewModel.getTripByTripId(tripId: tripId)
            viewModel.getTripEvaList(trip_id: tripId)
        }
        
        .edgesIgnoringSafeArea(.bottom)
        .actionSheet(isPresented: $viewModel.isScore) {
            let score5: ActionSheet.Button = .default(Text("非常满意")) {
                viewModel.postEva(tripId: tripId, score: 5)
            }
            let score4: ActionSheet.Button = .default(Text("满意")) {
                viewModel.postEva(tripId: tripId, score: 4)
            }
            let score3: ActionSheet.Button = .default(Text("一般")) {
                viewModel.postEva(tripId: tripId, score: 3)
            }
            let score2: ActionSheet.Button = .destructive(Text("不满意")) {
                viewModel.postEva(tripId: tripId, score: 2)
            }
            let score1: ActionSheet.Button = .destructive(Text("非常不满意")) {
                viewModel.postEva(tripId: tripId, score: 1)
            }
            let cancel: ActionSheet.Button = .cancel()
            
            return ActionSheet(
                title: Text("为此次旅行打个分呗～"),
                message: Text("您的评价非常重要哟，恳请认真对待哟～～～"),
                buttons: [
                    score5, score4, score3, score2, score1, cancel
                ]
            )
        }
    }
    
    var inputEvaView: some View {
        HStack(alignment: .center, spacing: 8)  {
            TextField("说说这次旅行的感受吧～", text: $viewModel.inputEvaText)
                .submitLabel(!viewModel.inputEvaText.isEmpty ? .send : .done)
                .onSubmit {
                    if !viewModel.inputEvaText.isEmpty {
                        viewModel.isScore.toggle()
                    } else {
                        ProgressHUD.error("评价不能为空哟～")
                    }
                }
                .textFieldStyle(.roundedBorder)
            
            checkboxView(text: "匿名", isClick: viewModel.isHiddenMe) {
                viewModel.isHiddenMe.toggle()
            }
        }
        .padding(.bottom, 32)
        .padding(.top, 12)
        .padding(.horizontal, 12)
        .background(.white)
        .cornerRadius(10)
        .padding(.bottom, keyboard.currentHeight)
        .animation(.spring)
    }
    
    private func evaluate() -> some View {
        VStack(alignment: .center, spacing: 4)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("用户评价(\(viewModel.trip.reviewCount))")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 12)
            
            if viewModel.trip.reviewCount == 0 {
                VStack(alignment: .center, spacing: 0)  {
                    Image(.noEva)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.4)
                    Text("还没有人评论")
                        .foregroundColor(.gray)
                }
            } else {
                ForEach(viewModel.tripEvaList, id: \.evaluateId) { eva in
                    evaluateItem(eva: eva)
                    Divider()
                }
                .onAppear {
                    
                }
            }
        }
    }
    
    private func evaluateItem(eva: EvaluateModel) -> some View {
        VStack(alignment: .leading, spacing: 8)  {
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
                
                HStack(alignment: .center, spacing: 0)  {
                    ForEach(0..<eva.score) { score in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    ForEach(0..<5 - eva.score) { star in
                        Image(systemName: "star")
                            .foregroundColor(.yellow)
                    }
                }
                .font(.system(size: 14))
                
            }
            Text(eva.content)
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    SubscribeView()
}

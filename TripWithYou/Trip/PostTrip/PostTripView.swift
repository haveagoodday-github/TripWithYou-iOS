//
//  PostTripView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
// 导游发布Trip

import SwiftUI

struct PostTripView: View {
    @StateObject private var viewModel: PostTripViewModel = PostTripViewModel()
    @StateObject private var rViewModel: RealNameViewModel = RealNameViewModel()
    @FocusState var focus: PostTripForm?
    
    var body: some View {
        Form() {
            Section("标题") {
                TextField("北京七日游", text: $viewModel.tripForm.title)
                    .focused($focus, equals: .title)
                    .submitLabel(.next)
                    .onSubmit {
                        focus = .background
                    }
                    
            }
            
            
            Section {
                TextEditor(text: $viewModel.tripForm.background)
                    .frame(height: 200)
                    
            } header: {
                Text("内容介绍")
            } footer: {
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    Text("当前内容字数: \(viewModel.tripForm.background.count) / 1000")
                        .foregroundColor(viewModel.tripForm.background.count > 1000 ? .red : .gray)
                }
            }
            
            Section {
                TextField("服务标题1", text: $viewModel.tripForm.serviceTitle)
                    
                TextField("服务内容", text: $viewModel.tripForm.serviceContent)
                    
            } header: {
                HStack(alignment: .center, spacing: 0)  {
                    Stepper("添加服务项目", value: $viewModel.tripForm.serviceNum, in: 1...viewModel.tripForm.maxServiceNum)
                }
            }
            
            if viewModel.tripForm.serviceNum > 1 {
                Section() {
                    TextField("服务标题2", text: $viewModel.tripForm.serviceTitle2)
                        
                    TextField("服务内容", text: $viewModel.tripForm.serviceContent2)
                        
                }
            }
            
            if viewModel.tripForm.serviceNum > 2 {
                Section() {
                    TextField("服务标题3", text: $viewModel.tripForm.serviceTitle3)
                        
                    TextField("服务内容", text: $viewModel.tripForm.serviceContent3)
                        
                }
            }

            
            
            
            
            Section {
                TextField("价格", text: $viewModel.tripForm.price)
                    .keyboardType(.numberPad)
            } header: {
                Text("设置价格，以人民币为单位")
            } footer: {
                Text("设置合理的价格更能吸引用户哟～")
            }

            
            Section("伴游服务周期") {
                DatePicker(selection: $viewModel.tripForm.tripStartTime, displayedComponents: .date) {
                    Text("设置开始时间")
                }
                DatePicker(selection: $viewModel.tripForm.tripEndTime, displayedComponents: .date) {
                    Text("设置结束时间")
                }
            }
            
            
            Section("上传图片") {
//                EditDynamicImagesView(images: $viewModel.images, picker: $viewModel.picker) { _ in
//                    
//                }
//                .frame(maxHeight: 300)
//                .cornerRadius(10)
                updateImageView(images: $viewModel.images, picker: $viewModel.picker)
            }

            
            Button(action: {
                viewModel.postTrip()
            }, label: {
                Text("发布")
            })
            
        }
        .blur(radius: rViewModel.isRealName != .pass ? 6 : 0)
        .navigationBarTitle("发布", displayMode: .inline)
        .closeKeyboard()
        .overlay(alignment: .center) {
            if rViewModel.isRealName != .pass {
                cover
            }
        }
    }
    
    var cover: some View {
        ZStack(alignment: .center) {
            Color.white.opacity(0.4)
            VStack(alignment: .center, spacing: 12)  {
                Text(!rViewModel.disable ? "实名后，即可发布" : "已提交实名认证，等待审核中...")
                if !rViewModel.disable {
                    NavigationLink(destination: RealNameView(viewModel: rViewModel)) {
                        Text("去实名")
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                
            }
        }
    }
}

struct updateImageView: View {
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            if !images.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Image(uiImage: images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 100)
                            .cornerRadius(10)
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "xmark.circle.fill")
                                    .scaledToFill()
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                    .padding(4)
                                    .onTapGesture {
                                        images.remove(at: index)
                                    }
                            }
                    }
                    
                    if images.count < 6 {
                        plusUpdataImageButton(images: $images, selectionLimit: 6)
                    }
                }
                
            } else if images.count < 6 {
                plusUpdataImageButton(images: $images, selectionLimit: 6)
            }
        }
        .padding(.horizontal, 12)
    }
    

}


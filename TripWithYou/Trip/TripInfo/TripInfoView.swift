//
//  TripInfoView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/20.
//

import SwiftUI

struct TripInfoView: View {
    @StateObject var viewModel = TripInfoViewModel()
    var body: some View {
        ZStack(alignment: .top) {
            Image(.myHeadBg2)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12)  {
                    topUserInfoView
//                    Divider()
//                        .padding(.top, 18)
                    otherInfoView
                    Spacer()
                    
                    
                    OtherService()
//                    Spacer()
                }
                .padding(.horizontal, 12)
            }
        }
        .overlay(alignment: .bottom) {
            editPersonelInfoButtonView
                .padding(.bottom, 12)
        }
        .fullScreenCover(isPresented: $viewModel.isOpenEditPersonelInfoFullCover, content: {
            editPersonelInfoFullCoverView
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

extension TripInfoView {
    var topUserInfoView: some View {
        HStack(alignment: .center, spacing: 8)  {
            KFImageView(viewModel.tripInfo?.avatar ?? "")
                .frame(width: 80, height: 80)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 4)  {
                HStack(alignment: .center, spacing: 4)  {
                    Text(viewModel.tripInfo?.nickname ?? "")
                        .font(.system(size: 18, weight: .bold))
                    Image(viewModel.tripInfo?.sex == 1 ? .boy : .gril)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                Text(calculateAge(birthDateString: viewModel.tripInfo?.birthday ?? "0") + "岁")
                    .foregroundColor(.gray)
                
                HStack(alignment: .center, spacing: 4)  {
                    Text(viewModel.language1)
                    Text(viewModel.language2)
                    Text(viewModel.language3)
                }
                .foregroundColor(.black)
            }
        }
    }
    
    
    var otherInfoView: some View {
        VStack(alignment: .leading, spacing: 0)  {
//            Text("邮箱: \(viewModel.tripInfo?.email ?? "未填写邮箱")")
        }
    }
    
    
    
    var editPersonelInfoButtonView: some View {
        Button {
            viewModel.isOpenEditPersonelInfoFullCover.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                .overlay {
                    Text("编辑个人资料")
                        .foregroundColor(.white)
                }
        }
        
    }
    
    
    var editPersonelInfoFullCoverView: some View {
        VStack(alignment: .center, spacing: 0)  {
            List {
                
                Section("头像") {
                    if let avatar = viewModel.avatar.first {
                        Image(uiImage: avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .clipped()
                            .selectImageSheet(images: $viewModel.avatar, selectionLimit: 1)
                    } else {
                        Image(systemName: "plus")
                            .font(.title)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black.opacity(0.4))
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(10)
                            .selectImageSheet(images: $viewModel.avatar, selectionLimit: 1)
                    }
                    
                }
                
                Section("必要信息*") {
                    TextField("真实姓名", text: $viewModel.name)
                    TextField("昵称", text: $viewModel.nickname)
                    TextField("手机号码", text: $viewModel.phone)
                        .keyboardType(.namePhonePad)
                }
                
                Section("背景资料*") {
                    TextEditor(text: $viewModel.backgrounp)
                        .frame(height: 300)
                }
                
                Section("擅长的语言*") {
                    HStack(alignment: .center, spacing: 12)  {
                        Picker("擅长的语言1", selection: $viewModel.language11) {
                            ForEach(viewModel.allLanguages, id: \.id) { language in
                                Text(language.languageName)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("擅长的语言2", selection: $viewModel.language22) {
                            ForEach(viewModel.allLanguages, id: \.id) { language in
                                Text(language.languageName)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("擅长的语言3", selection: $viewModel.language33) {
                            ForEach(viewModel.allLanguages, id: \.id) { language in
                                Text(language.languageName)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                .onChange(of: viewModel.language33, perform: { newValue in
                    print("---\(newValue)")
                })
                
                Section("其他信息") {
                    DatePicker("出生日期", selection: $viewModel.birthday, displayedComponents: .date)
                    TextField("电子邮箱", text: $viewModel.email)
                }
                
                
                
                
            }
            Spacer()
        }
        .padding(.top, 42)
        .overlay(alignment: .topLeading) {
            HStack(alignment: .center, spacing: 0)  {
                    Text("取消")
                    .font(.system(size: 18, weight: .bold))
                    .onTapGesture {
                        viewModel.isOpenEditPersonelInfoFullCover.toggle()
                    }
                    .padding(.bottom, 12)
                
                Spacer()
                
                Button {
                    // 保存信息
                    viewModel.isOpenEditPersonelInfoFullCover.toggle()
                } label: {
                    Text("保存")
                        .font(.system(size: 18, weight: .bold))
                }
                .padding(.bottom, 12)

                
            }
            .edgesIgnoringSafeArea(.top)
            .padding(.horizontal, 12)
            .padding(.top , 18)
            .background(.white)
        }
        .onAppear {
            viewModel.initializeTripInfo()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    TripInfoView()
}





//
//  PersonnelInfoView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/24.
//

import SwiftUI

struct PersonnelInfoView: View {
    @StateObject private var viewModel: PersonnelInfoViewModel = PersonnelInfoViewModel()
    var userId: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.myHeadBg2)
                .resizable()
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 12)  {
                    userInfo
                    moreTriperInfo
                    if viewModel.userInfo.type == 2 {
                        triperInfo
                    }
                    if UserCache.shared.getUserInfo()?.type == 2 && viewModel.userInfo.realStatus == 1 {
                        extensionInfo
                    }
                    Spacer(minLength: 65)
                }
                .padding(12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getUserInfo(userId: userId)
            if viewModel.userInfo.type == 2 {
                viewModel.getTriperInfo(userId: userId)
            }
        }
        .overlay(alignment: .bottom) {
            // 非本人 / 管理员 向用户发送信息
            if userId != UserCache.shared.getUserInfo()?.userId && UserCache.shared.getUserInfo()?.type != 3 {
                HStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    Text("发消息")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 14)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(30)
                .padding(.horizontal, 8)
                .padding(.bottom, 24)
                .openChatView(viewModel: ChatViewModel(userId: userId))
            }
        }
    }
    
    
    var extensionInfo: some View {
        VStack(alignment: .center, spacing: 18)  {
            titleItemView(name: "实名信息", imageName: nil)
            baseInfoItemView(name: "真实姓名:", content: viewModel.userInfo.realname)
            baseInfoItemView(name: "身份证号码:", content: viewModel.userInfo.identificationCard)
            
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.6))
        .cornerRadius(10)
    }
    
    var moreTriperInfo: some View {
        VStack(alignment: .leading, spacing: 18)  {
            titleItemView(name: "动态图片", imageName: nil)
            DynamicImagesView(dynamicImages: viewModel.dynamicImages)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.6))
        .cornerRadius(10)
    }
    
    
    var userInfo: some View {
        HStack(alignment: .center, spacing: 12)  {
            KFImageView(viewModel.userInfo.avatar, .fill)
                .frame(width: 80, height: 80)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 8)  {
                HStack(alignment: .center, spacing: 4)  {
                    Text(viewModel.userInfo.nickname)
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(calculateAge(birthDateString: viewModel.userInfo.birthday ?? "0") + "岁")
                        .foregroundColor(.gray)
                }
                Image(viewModel.userInfo.sex == 1 ? .boy : .gril)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            Spacer()
        }
    }
    
    var triperInfo: some View {
        VStack(alignment: .leading, spacing: 18)  {
            titleItemView(name: "基本信息", imageName: nil)
                .onTapGesture {
                    // 编辑个人信息
                    viewModel.isShowSheet.toggle()
                }
            
            
            VStack(alignment: .leading, spacing: 16)  {
                baseInfoItemView(name: "真实姓名:", content: viewModel.triperInfo.name)
                baseInfoItemView(name: "个人简介:", content: viewModel.triperInfo.intro)
                baseInfoItemView(name: "语言能力:", content: viewModel.triperInfo.language1)
                baseInfoItemView(name: "语言能力:", content: viewModel.triperInfo.language2)
                baseInfoItemView(name: "语言能力:", content: viewModel.triperInfo.language3)
                baseInfoItemView(name: "联系电话:", content: viewModel.triperInfo.connectionPhone)
            }
            
            
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.6))
        .cornerRadius(10)
    }
}




struct ShowUserInfoSheet: ViewModifier {
    var userId: Int
    var isAction: Bool
    @State var isClose: Bool = false
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if isAction {
                    isClose.toggle()
                }
            }
            .sheet(isPresented: $isClose) {
                NavigationView {
                    PersonnelInfoView(userId: userId)
                }
            }
    }
}



struct selectImageSheetViewModifier: ViewModifier {
    @Binding var images: [UIImage]
    @State var picker: Bool = false
    var selectionLimit: Int = 1
    
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                picker.toggle()
            }
            .sheet(isPresented: $picker, content: {
                ImagePickerSecond(images: $images, picker: $picker, selectionLimit: selectionLimit)
            })
            .onChange(of: images, perform: { newValue in
                if images.count > 6 {
                    images.removeSubrange(6..<images.count)
                }
            })
    }
}


struct selectVideoSheetViewModifier: ViewModifier {
    @Binding var videos: [URL]
    @Binding var images: [UIImage]
    @State var picker: Bool = false
    var selectionLimit: Int = 1
    
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                picker.toggle()
            }
            .sheet(isPresented: $picker, content: {
                ImagePickerSecond(images: $images, picker: $picker,videoURLs: $videos, selectionLimit: selectionLimit, allowVideo: true)
            })
            .onChange(of: images, perform: { newValue in
                if images.count > 6 {
                    images.removeSubrange(6..<images.count)
                }
            })
    }
}



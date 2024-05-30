//
//  UserInfoView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/19.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject var viewModel: UserInfoViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(.myHeadBg2)
                .resizable()
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .center, spacing: 12)  {
                    userInfo
                    moreTriperInfo
                    if UserCache.shared.getUserInfo()?.type == 2 {
                        triperInfo
                    }
                    OtherService()
                    Spacer(minLength: 65)
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.isShowSheet, content: {
            updateUserBaseInfo
        })
    }
    
    
    var updateUserBaseInfo: some View {
        Form {
            Section("必要信息*") {
                TextField("真实姓名", text: $viewModel.name)
                
                TextField("联系方式", text: $viewModel.connectionPhone)
                    .keyboardType(.namePhonePad)
            }
            
            Section("个人简介") {
                TextEditor(text: $viewModel.intro)
                    .frame(height: 300)
            }
            
            
            Section("擅长的语言1:") {
                Picker("擅长的语言1", selection: $viewModel.language1) {
                    ForEach(viewModel.allLanguages, id: \.id) { language in
                        Text(language.languageName)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section("擅长的语言2:") {
                Picker("擅长的语言2", selection: $viewModel.language2) {
                    ForEach(viewModel.allLanguages, id: \.id) { language in
                        Text(language.languageName)
                    }
                }
                .pickerStyle(.menu)
            }
            
            
            Section("擅长的语言3:") {
                Picker("擅长的语言3", selection: $viewModel.language3) {
                    ForEach(viewModel.allLanguages, id: \.id) { language in
                        Text(language.languageName)
                    }
                }
                .pickerStyle(.menu)
            }
            
            
            Button {
                // Save
                viewModel.saveUpdateUserBaseInfo()
            } label: {
                Text("保存")
            }
            
        }
        .onAppear {
            viewModel.getAllLanguages()
        }
    }
    
    var userInfo: some View {
        NavigationLink(
            destination: EditUserInfoView(viewModel: viewModel)
        ) {
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
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
                    .font(.system(size: 24, weight: .light))
            }
        }
    }
    
    var triperInfo: some View {
        VStack(alignment: .leading, spacing: 18)  {
            titleItemView(name: "基本信息", imageName: "chevron.forward")
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
    
    
    var moreTriperInfo: some View {
        VStack(alignment: .leading, spacing: 18)  {
            NavigationLink(destination: EditDynamicImagesView(images: $viewModel.images, picker: $viewModel.picker) { completion in
                viewModel.updateDynamicImages() {
                    completion()
                }
            }) {
                titleItemView(name: "动态图片", imageName: "chevron.forward")
            }
            DynamicImagesView(dynamicImages: viewModel.dynamicImages)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.6))
        .cornerRadius(10)
    }
}


struct titleItemView: View {
    let name: String
    let imageName: String?
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            Text(name)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            if let image = imageName {
                Image(systemName: image)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct DynamicImagesView: View {
    var dynamicImages: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0)  {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                ForEach(0..<(dynamicImages.count > 6 ? 6 : dynamicImages.count), id: \.self) { index in
                    KFImageView(dynamicImages[index], .fill)
                        .frame(height: 100)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.28)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    
}

struct EditDynamicImagesView: View {
//    @StateObject var viewModel: UserInfoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    var saveAction: (@escaping () -> ()) -> ()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(.myHeadBg2)
                .resizable()
                .ignoresSafeArea()
            
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
        .onChange(of: images, perform: { newValue in
            if images.count > 6 {
                images.removeSubrange(6..<images.count)
            }
        })
        .navigationBarItems(trailing: trailingBar)
    }
    
    
    var trailingBar: some View {
        Button {
            saveAction() {
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("保存")
        }
    }
    
}

struct plusUpdataImageButton: View {
    @Binding var images: [UIImage]
    let selectionLimit: Int
    var body: some View {
        Image(systemName: "plus")
            .font(.title)
            .frame(height: 100)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.28)
            .foregroundColor(.black.opacity(0.3))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .selectImageSheet(images: $images, selectionLimit: selectionLimit)
    }
}


struct baseInfoItemView: View {
    var name: String
    var content: String?
    var body: some View {
        HStack(alignment: .center, spacing: 8)  {
            Text(name)
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .regular))
            Text(content ?? "空")
                .foregroundColor(content != nil ? .black : .gray)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
    }
}


struct EditUserInfoView: View {
    @StateObject var viewModel: UserInfoViewModel
    @FocusState var fieldInFocus: OnboardingField?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form() {
            Section("头像") {
                
                if let avatar = viewModel.avatar.last {
                    Image(uiImage: avatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .clipped()
                        .selectImageSheet(images: $viewModel.avatar, selectionLimit: 1)
                } else {
                    KFImageView(viewModel.userInfo.avatar, .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .clipped()
                        .selectImageSheet(images: $viewModel.avatar, selectionLimit: 1)
                }
                
                
            }
            
            Section("基本信息") {
                HStack(alignment: .center, spacing: 4)  {
                    Text("昵称:")
                    TextField(viewModel.userInfo.nickname, text: $viewModel.nickname)
                        .focused($fieldInFocus, equals: .nickname)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .phone
                        }
                }
                
                HStack(alignment: .center, spacing: 4)  {
                    Text("手机号码:")
                    TextField(viewModel.userInfo.phone, text: $viewModel.phone)
                        .keyboardType(.numberPad)
                        .focused($fieldInFocus, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .email
                        }
                }
                
                
                
                HStack(alignment: .center, spacing: 32)  {
                    checkboxView(text: "女", isClick: viewModel.sex == 0) {
                        viewModel.sex = 0
                    }
                    checkboxView(text: "男", isClick: viewModel.sex == 1) {
                        viewModel.sex = 1
                    }
                }
                DatePicker(selection: $viewModel.birthday, displayedComponents: .date) {
                    Text("设置生日")
                }
                
                HStack(alignment: .center, spacing: 4)  {
                    Text("邮箱:")
                    TextField("请设置邮箱", text: $viewModel.email, prompt: Text("请设置邮箱"))
                        .keyboardType(.emailAddress)
                        .focused($fieldInFocus, equals: .email)
                        .submitLabel(.done)
                }
                
                
                
            }
        }
        .navigationTitle("编辑个人资料")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingBar)
        .onDisappear {
            viewModel.disappear()
        }
    }
    
    var trailingBar: some View {
        Button {
            viewModel.updateUserInfo() { _ in
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("保存")
        }
        
    }
}



struct OtherService: View {
    var body: some View {
        VStack(alignment: .center, spacing: 18)  {
            HStack(alignment: .center, spacing: 0)  {
                Text("其他服务")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            
            VStack(alignment: .center, spacing: 16)  {
                
//                OtherServiceItemView(iamgeName: "rectangle.on.rectangle", name: "关于")
                
                NavigationLink(destination: SettingView()) {
                    OtherServiceItemView(iamgeName: "gear", name: "设置")
                }
                
                
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.6))
        .cornerRadius(10)
    }
}


struct OtherServiceItemView: View {
    let iamgeName: String
    let name: String
    var body: some View {
        HStack(alignment: .center, spacing: 6)  {
            Image(systemName: iamgeName)
                .font(.system(size: 16, weight: .light))
            Text(name)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
    }
}

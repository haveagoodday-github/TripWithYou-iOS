//
//  ManageUsersView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import SwiftUI

struct ManageUsersView: View {
    @StateObject var viewModel: ManageUsersViewModel
    var body: some View {
        VStack(alignment: .center, spacing: 14)  {
            
            topColorIntro
            
            List(viewModel.allUsersArray, id: \.userId) { user in
                ManageUserItemView(user: user, viewModel: viewModel)
            }
            .listStyle(.inset)
            .refreshable {
                viewModel.getAllUsers()
            }
        }
        .navigationTitle("管理用户")
        .navigationBarTitleDisplayMode(.inline)
        .actionSheet(isPresented: $viewModel.isEditUserType, content: {
            viewModel.getActionSheet()
        })
        .refreshable {
            viewModel.getAllUsers()
        }
        .navigationBarItems(trailing: trailingView)
        
    }
    
    
    var trailingView: some View {
        NavigationLink(destination: SettingView()) {
            Image(systemName: "gear")
        }
    }
    
    var topColorIntro: some View {
        HStack(alignment: .center, spacing: 18)  {
            HStack(alignment: .center, spacing: 3)  {
                miniTitleView(text: "用户:")
                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
            }
            
            HStack(alignment: .center, spacing: 3)  {
                miniTitleView(text: "导游:")
                Circle()
                    .fill(.green)
                    .frame(width: 10, height: 10)
            }
            
            HStack(alignment: .center, spacing: 3)  {
                miniTitleView(text: "管理员:")
                Circle()
                    .fill(.red)
                    .frame(width: 10, height: 10)
            }
            
            HStack(alignment: .center, spacing: 3)  {
                miniTitleView(text: "黑名单:")
                Circle()
                    .fill(.gray)
                    .frame(width: 10, height: 10)
            }
        }
    }
}


struct ManageUserItemView: View {
    var user: UserInfo
    @StateObject var viewModel: ManageUsersViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            
            HStack(alignment: .center, spacing: 4)  {
                miniTitleView(text: "用户名:")
                Text(user.username)
                Spacer()
                miniTitleView(text: "用户类型:")
                Text(user.type == 1 ? "用户" : user.type == 2 ? "导游" : "管理员")
            }
            
            HStack(alignment: .center, spacing: 4)  {
                KFImageView(user.avatar, .fill)
                    .frame(width: 40, height: 40)
                    .cornerRadius(6)
                    .clipped()
                    .showUserInfoSheet(userId: user.userId)
                
                VStack(alignment: .leading, spacing: 2)  {
                    HStack(alignment: .center, spacing: 4)  {
                        Text(user.nickname)
                            .font(.system(size: 14, weight: .bold))
                        Image(user.sex == 1 ? .boy : .gril)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    Text("\(calculateAge(birthDateString: user.birthday ?? "0"))岁")
                        .font(.system(size: 12, weight: .medium))
                }
            }
            
            HStack(alignment: .center, spacing: 0)  {
                if let email = user.email {
                    HStack(alignment: .center, spacing: 4)  {
                        miniTitleView(text: "邮箱:")
//                        Text("[\(email)](https://baidu.com)")
                        Text(email)
                    }
                }
                Spacer()
                HStack(alignment: .center, spacing: 4)  {
                    miniTitleView(text: "手机号码:")
                    Text(user.phone)
                }
            }
            
            if let images = user.dynamicImages {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3), content: {
                    ForEach(stringToArray(string: images), id: \.self) { image in
                        KFImageView(image, .fill)
                            .frame(height: 100)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.28)
                            .cornerRadius(10)
                        
                    }
                })
            }
            
            Text(user.createTime ?? "")
            
            if user.realStatus == 1 {
                Text("身份证号码：\(user.identificationCard!)")
                Text("真实姓名：\(user.realname!)")
            }
            
            
            
        }
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(user.type == 1 ? .blue : user.type == 2 ? .green : .red)
                .frame(width: 10, height: 10)
                .padding([.top, .leading], 6)
                .onTapGesture {
                    viewModel.isEditUserType.toggle()
                    viewModel.currentUserId = user.userId
                }
        }
    }
}

struct miniTitleView: View {
    let text: String
    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .font(.system(size: 12, weight: .medium))
    }
}


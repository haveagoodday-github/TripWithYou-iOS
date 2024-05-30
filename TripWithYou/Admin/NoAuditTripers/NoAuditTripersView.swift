//
//  NoAuditTripersView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import SwiftUI

struct NoAuditTripersView: View {
    @StateObject private var viewModel: NoAuditTripersViewModel = NoAuditTripersViewModel()
    var body: some View {
        
        
        VStack(alignment: .center, spacing: 8)  {
            picker
            if viewModel.selectedManagementType != "未实名用户和导游" {
                triper
                    .animation(.spring)
            } else {
                if viewModel.userlist.isEmpty {
                    VStack(alignment: .center, spacing: 0)  {
                        Spacer()
                        Text("暂无需审核")
                        Spacer()
                    }
                } else {
                    user
                        .animation(.spring)
                }
            }
            Spacer()
        }
        .navigationBarTitle("审核用户/伴游", displayMode: .inline)
    }
    
    
    var user: some View {
        List($viewModel.userlist, id: \.userId) { $user in
            ManageUserRealItemView(user: $user, viewModel: viewModel)
        }
        .navigationBarItems(trailing: userTrailingView)
        .refreshable {
            viewModel.getUsers()
        }
    }
    
    var userTrailingView: some View {
        Button {
            viewModel.updateIdentityStatusAll() {
                ProgressHUDView.dismiss()
                viewModel.getUsers(page: 1)
            }
        } label: {
            Text("提交更改")
        }
        
    }
    
    var triper: some View {
        List(viewModel.tripersArray, id: \.triperId) { triper in
            NoAuditTriperItemView(triper: triper, viewModel: viewModel)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        viewModel.auditTriper(triperId: triper.triperId, state: 1)
                    } label: {
                        Label("通过", systemImage: "person.badge.plus")
                    }
                    .tint(.green)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        viewModel.auditTriper(triperId: triper.triperId, state: 2)
                    } label: {
                        Label("不通过", systemImage: "person.badge.minus")
                    }
                    .tint(.red)
                }
        }
        .listStyle(.inset)
        .refreshable {
            viewModel.getTripers()
        }
    }
    
    var picker: some View {
        Picker("管理类型", selection: $viewModel.selectedManagementType) {
            ForEach(viewModel.managementType, id: \.self) { type in
                Text(type)
                    .id(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 12)
        .onChange(of: viewModel.selectedManagementType, perform: { newValue in
            if newValue == "未实名用户和导游" {
                viewModel.getUsers()
            } else {
                viewModel.getTripers()
            }
        })
    }
}


struct ManageUserRealItemView: View {
    @Binding var user: UserInfo
    var viewModel: NoAuditTripersViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                defaultUserInfoView(userId: user.userId, avatar: user.avatar, name: user.nickname, sex: user.sex, birthday: user.birthday)
                Spacer()
                Picker("审核状态", selection: Binding(
                    get: { user.realStatus ?? 0 },
                    set: { newStatus in
                        user.realStatus = newStatus
                        viewModel.updateUser(user)
                    })) {
                        ForEach(realStatusToAdmin.allCases, id: \.rawValue) { state in
                            Text(handleState(state.rawValue))
                                .tag(state.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
            }
        }
    }
    
    
    private func handleState(_ state: Int) -> String {
        switch state {
        case 0:
            "待验证"
        case 1:
            "验证通过"
        default:
            "验证不通过"
        }
    }
}

struct NoAuditTriperItemView: View {
    var triper: NotAuditTriperModel
    @StateObject var viewModel: NoAuditTripersViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4)  {
            
            defaultUserInfoView(userId: triper.userId, avatar: triper.avatar, name: triper.name, sex: triper.sex, birthday: triper.birthday)
            
            HStack(alignment: .center, spacing: 3)  {
                Text(triper.language1 ?? "未设置")
                Text(triper.language2 ?? "未设置")
                Text(triper.language3 ?? "未设置")
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.gray)
            
            Text(triper.intro ?? "无介绍")
        
            
        }
    }
}


struct defaultUserInfoView: View {
    var userId: Int
    var avatar: String
    var name: String?
    var sex: Int
    var birthday: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 4)  {
            KFImageView(avatar, .fill)
                .frame(width: 40, height: 40)
                .cornerRadius(6)
                .clipped()
                .showUserInfoSheet(userId: userId)
            VStack(alignment: .leading, spacing: 2)  {
                HStack(alignment: .center, spacing: 2)  {
                    Text(name ?? "未命名")
                        .bold()
                    Image(sex == 1 ? .boy : .gril)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
                Text("\(calculateAge(birthDateString: birthday))岁")
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .medium))
            }
        }
    }
}


struct auditButtonView: View {
    let pass: () -> ()
    let prevent: () -> ()
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            Button(action: {
                prevent()
            }, label: {
                Text("不通过")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.red)
                    .cornerRadius(6)
            })
            
            Spacer()
            
            Button(action: {
                pass()
            }, label: {
                Text("通过")
                    .font(.system(size: 14, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.green)
                    .cornerRadius(6)
            })
            
        }
    }
}

#Preview {
    NoAuditTripersView()
}

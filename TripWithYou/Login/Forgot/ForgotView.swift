//
//  ForgotView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI

struct ForgotView: View {
    @StateObject private var viewModel: ForgotViewModel = ForgotViewModel()
    @FocusState var fieldInFocus: OnboardingField?
    var body: some View {
        List {
            Section() {
                TextField("要找回帐号的用户名", text: $viewModel.username, prompt: Text("请输入要找回帐号的用户名"))
                    .focused($fieldInFocus, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        fieldInFocus = .phone
                    }
                TextField("要找回帐号的手机号码", text: $viewModel.phone, prompt: Text("请输入要找回帐号的手机号码"))
                    .focused($fieldInFocus, equals: .phone)
                    .submitLabel(.next)
                    .onSubmit {
                        fieldInFocus = .newPassword
                    }
                    
            }
            
            Section() {
                TextField("设置新密码", text: $viewModel.newPassword, prompt: Text("请输入新密码"))
                    .focused($fieldInFocus, equals: .newPassword)
                    .submitLabel(.done)
                    .onSubmit {
                        viewModel.reset()
                    }
            }
            
            Section() {
                Button(action: {
                    viewModel.reset()
                }, label: {
                    Text("重设密码")
                })
                .disabled(viewModel.username.isEmpty || viewModel.phone.isEmpty || viewModel.newPassword.isEmpty)
            }
        }
    }
}

#Preview {
    ForgotView()
}

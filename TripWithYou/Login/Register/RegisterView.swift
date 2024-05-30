//
//  RegisterView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @FocusState var fieldInFocus: OnboardingField?
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            Form {
                Section() {
                    TextField("请设置用户名", text: $viewModel.username, prompt: Text("请设置用户名"))
                        .focused($fieldInFocus, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .password
                        }
                    TextField("请设置密码", text: $viewModel.password, prompt: Text("请设置密码"))
                        .focused($fieldInFocus, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .phone
                        }
                    
                    TextField("请设置手机号码", text: $viewModel.phone, prompt: Text("请设置手机号码"))
                        .focused($fieldInFocus, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit {
                            fieldInFocus = .nickname
                        }
                    
                    TextField("请设置昵称", text: $viewModel.nickname, prompt: Text("请设置昵称"))
                        .focused($fieldInFocus, equals: .nickname)
                        .submitLabel(.return)
                        .onSubmit {
                            viewModel.register()
                        }
                    
                }
                
                if let image = viewModel.verCode {
                    Section() {
                        HStack(alignment: .center, spacing: 12)  {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.5))
                                .frame(height: 40)
                                .overlay {
                                    TextField("请输入验证码", text: $viewModel.captchaCode, prompt: Text("请输入验证码"))
                                        .padding(4)
                                        .font(.system(size: 18, weight: .medium))
                                        .focused($fieldInFocus, equals: .password)
                                        .submitLabel(.return)
                                        .onSubmit {
                                            viewModel.register()
                                        }
                                }
                            
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 40)
                                .cornerRadius(8)
                                .onTapGesture {
                                    viewModel.getVerCode()
                                }
                        }
                    }
                }
                
                Section() {
                    Button(action: {
                        viewModel.register()
                    }, label: {
                        Text("注册")
                    })
                }
            }
        }
        .navigationTitle("注册")
        .navigationBarTitleDisplayMode(.inline)
        .background {
            NavigationLink(
                destination: LoginView().navigationBarBackButtonHidden(true),
                isActive: $viewModel.isLogin,
                label: {
                    
                })
            
        }
    }
}


struct checkboxView: View {
    let text: String
    var isClick: Bool
    let action: () -> ()
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            Image(systemName: isClick ? "circle.circle" : "circle")
                .foregroundColor(isClick ? .blue : .gray)
            Text(text)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    RegisterView()
}

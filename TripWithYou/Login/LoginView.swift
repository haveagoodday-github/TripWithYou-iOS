//
//  LoginView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State var isGotoSelectIidentityView: Bool = false
    @FocusState var fieldInFocus: OnboardingField?
    var body: some View {
        ZStack(alignment: .top) {
            Image(.myHeadBg2)
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12)  {
                Spacer()
                
                // TEST
                Picker("选择用户", selection: $viewModel.selectUserType) {
                    ForEach(viewModel.selectUserTypeList, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectUserType, perform: { newValue in
                    switch newValue {
                    case "游客":
                        viewModel.username = "User"
                    case "导游":
                        viewModel.username = "Trip"
                    default:
                        viewModel.username = "Admin"
                    }
                    viewModel.password = "123"
                })
                .onAppear {
                    viewModel.selectUserType = "游客"
                }
                
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 50)
                    .overlay {
                        TextField("请输入用户名", text: $viewModel.username, prompt: Text("请输入用户名"))
                            .padding(4)
                            .font(.system(size: 18, weight: .medium))
                            .submitLabel(.next)
                            .focused($fieldInFocus, equals: .username)
                            .onSubmit {
                                fieldInFocus = .password
                            }
                    }
                    
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: 50)
                    .overlay {
                        TextField("请输入密码", text: $viewModel.password, prompt: Text("请输入密码"))
                            .padding(4)
                            .font(.system(size: 18, weight: .medium))
                            .focused($fieldInFocus, equals: .password)
                            .submitLabel(.return)
                            .onSubmit {
                                viewModel.login()
                            }
                    }
                
                
                if let image = viewModel.verCode {
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
                                        viewModel.login()
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
                
                buttonView(btnText: "登陆", isClick: viewModel.username.isEmpty || viewModel.password.isEmpty || viewModel.captchaCode.isEmpty) {
                    viewModel.login()
                }
                
                HStack(alignment: .center, spacing: 0)  {
                    NavigationLink(destination: RegisterView()) {
                        Text("注册")
                    }
                    Spacer()
                    NavigationLink(destination: ForgotView()) {
                        Text("忘记密码")
                    }
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("伴游")
            .navigationBarTitleDisplayMode(.inline)
            .background(background)
            .padding(.horizontal, 12)
        }
        
    }
    
    var background: some View {
        Group {
            NavigationLink(
                destination: UserView(),
                isActive: $viewModel.isLogin_user,
                label: {
                    
                })
            NavigationLink(
                destination: TripView(),
                isActive: $viewModel.isLogin_trip,
                label: {
                    
                })
            NavigationLink(
                destination: SelectIidentityView(),
                isActive: $viewModel.isLogin_selectIidentity,
                label: {
                    
                })
            NavigationLink(
                destination: SelectIidentityView(),
                isActive: $isGotoSelectIidentityView,
                label: {
                    
                })
            NavigationLink(
                destination: AdminView(),
                isActive: $viewModel.isLogin_admin,
                label: {
                    
                })
        }
    }
}

struct buttonView: View {
    let btnText: String
    var isClick: Bool
    let action: () -> ()
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(btnText)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
        })
        .background(isClick ? Color.gray : Color.blue)
        .cornerRadius(10)
        .disabled(isClick)
    }
}


#Preview {
//    ContentView()
//    RegisterView()
//    ForgotView()
//    SelectIidentityView()
//    NavigationView {
//        UserView()
//    }
//    OrderView()
    
//    TripView()
    TripInfoView()
//    TripView()
    
    
//    TripItemDetailsView(trip: TripModel(id: 003, name: "王五", nickname: "小王", avatar: "https://example.com/avatar3.jpg", phone: "333333", email: "zzz@gmail.com", sex: 0, birthday: Date(), backgrounp: "欢迎来到这个美丽的地方！我是你们的引路人，将带领你们游览这个令人心旷神怡的地方。这里有悠久的历史，壮丽的自然景色和丰富的文化。我们将共同探索古老的遗迹，欣赏壮丽的自然风光，并品尝当地的美食。无论你是文化追随者，自然爱好者还是美食家，这里都能满足你的所有需求。让我们一起开始这段奇妙之旅，探索这个令人惊叹的地方！", languages: ["普通话", "英语", "西班牙语"], audit_status: 1, score: 4, evaluate: [
//        
//    ]))
}

//
//  SelectIidentityView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/21.
//

import SwiftUI

struct SelectIidentityView: View {
    @StateObject private var viewModel = SelectIidentityViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.myHeadBg2)
                .resizable()
                .scaledToFill()
                .rotationEffect(.degrees(90))
                .frame(height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 12)  {
                Text("请选择您的身份")
                    .font(.system(size: 26, weight: .bold))
                    .padding(.bottom, 8)
                
                HStack(alignment: .center, spacing: 12)  {
                    Spacer()
                    SelectIidentityCard(image: "travel", name: "我是游客", isSelected: viewModel.type == 1) {
                        viewModel.type = 1
                    }
                    SelectIidentityCard(image: "post", name: "我是导游", isSelected: viewModel.type == 2) {
                        viewModel.type = 2
                    }
                    Spacer()
                }
                
                Button(action: {
                    viewModel.updateUserType()
                }, label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.32, height: UIScreen.main.bounds.width * 0.17)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.15)
                            .overlay {
                                Image(systemName: "capslock.fill")
                                    .font(.system(size: 24, weight: .bold))
                                    .rotationEffect(.degrees(90))
                                    .foregroundColor(.white)
                            }
                    }
                })
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .navigationBarHidden(true)
        .background {
            NavigationLink(destination: UserView().navigationBarBackButtonHidden(true), isActive: $viewModel.isGoToUserView) {
                
            }
            NavigationLink(destination: TripView().navigationBarBackButtonHidden(true), isActive: $viewModel.isGoToTripView) {
                
            }
        }
        .overlay(alignment: .topLeading) {
            Image(systemName: "multiply")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 48)
                .padding(.leading, 24)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
        }
        .animation(.spring())
    }
}

struct SelectIidentityCard: View {
    let image: String
    let name: String
    var isSelected: Bool
    let action: () -> ()
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .frame(width: UIScreen.main.bounds.width * (isSelected ? 0.5 : 0.42), height: UIScreen.main.bounds.height * (isSelected ? 0.45 : 0.38))
            .shadow(radius: 3)
            .overlay {
                VStack(alignment: .center, spacing: 12)  {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * (isSelected ? 0.3 : 0.25), height: UIScreen.main.bounds.width * (isSelected ? 0.3 : 0.25))
                    Text(name)
                        .foregroundColor(isSelected ? .black : .gray)
                }
            }
            .opacity(isSelected ? 1 : 0.8)
            .onTapGesture {
                withAnimation(.spring) {
                    action()
                }
            }
    }
}

#Preview {
    SelectIidentityView()
}

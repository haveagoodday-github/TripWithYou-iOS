//
//  FeedbackView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//
/*
  用户结束订单后可以投诉伴游发送给管理员（选择投诉类型如：态度恶劣，额外收费等后，编辑文字），管理员审核后可取消伴游的资格
 */

import SwiftUI

struct FeedbackView: View {
    @StateObject var viewModel: FeedbackViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form() {
            Section(header: Text("选择投诉类型")) {
                Picker("投诉类型", selection: $viewModel.feedbackForm.type) {
                    ForEach(FeedbackType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type as FeedbackType?)
                    }
                }
                .pickerStyle(.menu)
                
                
            }
            
            Section(header: Text("投诉备注")) {
                TextField("请输入详细信息", text: $viewModel.feedbackForm.content)
            }
            
            Section(header: Text("投诉订单号")) {
                Text(String(viewModel.feedbackForm.tripId))
                    .foregroundColor(.gray)
            }
            
            
            Section() {
                Button(action: {
                    viewModel.submitFeedback() { isSuccess in
                        presentationMode.wrappedValue.dismiss()
                        if isSuccess {
                            ProgressHUDView.success("提交成功")
                        }
                    }
                }, label: {
                    Text("提交")
                })
            }
        }
        .navigationBarTitle("投诉", displayMode: .inline)
    }
}

#Preview {
    FeedbackView(viewModel: FeedbackViewModel(tripId: 1231))
}

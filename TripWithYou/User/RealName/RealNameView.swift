//
//  RealNameView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import SwiftUI


struct RealNameView: View {
    @StateObject var viewModel: RealNameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form() {
            Section("*必填") {
                TextField("真实姓名", text: $viewModel.realnameForm.realname)
                    .disabled(viewModel.disable)
                TextField("身份证号码", text: $viewModel.realnameForm.realId)
                    .disabled(viewModel.disable)
                    .keyboardType(.numbersAndPunctuation)
            }
            
            Section() {
                Button(action: {
                    viewModel.submitIdentity() { isSuccess in
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("提交审核")
                })
                .disabled(viewModel.disable)
            }
        }
        .navigationBarTitle("实名", displayMode: .inline)
    }
}

//
//  AnnouncementView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/20.
//

import SwiftUI

struct AnnouncementView: View {
    @StateObject var viewModel: AnnouncementViewModel
    var body: some View {
        List(viewModel.announcements, id: \.id) { announcement in
            VStack(alignment: .leading) {
                Text(announcement.title)
                    .font(.headline)
                Text(announcement.content)
                    .font(.subheadline)
                Text(announcement.createTime)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationBarTitle("历史公告", displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink("发布公告", destination: NewAnnouncementView(viewModel: viewModel)))
        .refreshable {
            viewModel.getAnnouncements()
        }
    }
}



struct NewAnnouncementView: View {
    @StateObject var viewModel: AnnouncementViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("公告标题")) {
                TextField("请输入标题", text: $viewModel.title)
            }
            Section(header: Text("公告内容")) {
                TextField("请输入内容", text: $viewModel.content)
            }
        }
        .navigationBarTitle("发布公告", displayMode: .inline)
        .navigationBarItems(trailing: Button("发布") {
            viewModel.addAnnouncement()
            presentationMode.wrappedValue.dismiss()
        })
    }
}

#Preview {
    AnnouncementView(viewModel: AnnouncementViewModel())
}





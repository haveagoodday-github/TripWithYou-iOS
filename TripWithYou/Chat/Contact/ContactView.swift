//
//  ContactView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import SwiftUI


struct ContactView: View {
    @StateObject var viewModel: ContactViewModel
    var body: some View {
        List(viewModel.contactList, id: \.userId) { user in
            NavigationLink(destination: ChatView(viewModel: ChatViewModel(userId: user.userId))) {
                ContactItemView(user: user)
            }
        }
        .navigationBarTitle("消息", displayMode: .inline)
        .searchable(text: $viewModel.searchText, prompt: Text("搜索昵称或者消息内容..."))
        .navigationBarItems(trailing: trailingView)
        
    }
    
    var trailingView: some View {
        NavigationLink(destination: AnnouncementCenterView()) {
            Image(systemName: "bell")
        }
    }
}


struct ContactItemView: View {
    let user: ContactModel
    var body: some View {
        HStack(alignment: .center, spacing: 12)  {
            
            KFImageView(user.avatar, .fill)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 12)  {
                Text(user.nickname)
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .bold))
                Text(user.lastMessageContent.contains("jpg") ? "图像" : user.lastMessageContent)
                    .foregroundColor(.gray)
                    .font(.system(size: 12, weight: .bold))
            }
            Spacer()
            
            Text(Timer.formatRelativeTime(from: user.lastMessageTime, ""))
                .foregroundColor(.gray)
                .font(.system(size: 12))
        }
        .frame(height: 52)
    }
}


struct AnnouncementCenterView: View {
    @StateObject var viewModel: AnnouncementViewModel = AnnouncementViewModel()
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
        .refreshable {
            viewModel.getAnnouncements()
        }
    }
}

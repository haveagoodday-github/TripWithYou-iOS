//
//  ChatView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/17.
//


import SwiftUI
import AVKit
import AVFoundation
import ExyteMediaPicker

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    //    @State var userId: Int
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack {
                        ForEach(viewModel.messages, id: \.messageId) { message in
                            ChatItemView(message: message)
                                .id(message.messageId)
                        }
                        
                        ForEach(viewModel.newMessages, id: \.messageId) { message in
                            ChatItemView(message: message)
                                .id(message.messageId)
                        }
                    }
                    .onChange(of: viewModel.messages, perform: { _ in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessage.messageId, anchor: .bottom)
                            }
                        }
                    })
                    .onChange(of: viewModel.newMessages, perform: { _ in
                        if let lastMessage = viewModel.newMessages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessage.messageId, anchor: .bottom)
                            }
                        }
                    })
                }
            }
            
            HStack {
                TextField("输入消息", text: $viewModel.textMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.done)
                    .padding()
                    .onSubmit {
                        viewModel.sendTextMessage(viewModel.textMessage)
                    }
                Image(systemName: "photo.on.rectangle.angled")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.horizontal, 4)
                    .onTapGesture {
                        viewModel.select.toggle()
                    }
                    .sheet(isPresented: $viewModel.select, content: {
                        MediaPicker(
                            isPresented: $viewModel.select,
                            onChange: { viewModel.medias = $0 }
                        )
                        .mediaSelectionLimit(1)
                        .mediaSelectionType(.photoAndVideo)
                    })
                    .onChange(of: viewModel.medias, perform: { newValue in
                        if let file = newValue.first {
                            Task {
                                await NetworkTools.uploadFile(file: file) { url in
                                    debugPrint("url: \(url)")
                                    viewModel.sendTextMessage(url, type: file.type == .image ? 1 : 2)
                                }
                            }
                        }
                    })
                
                
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .navigationBarTitle(viewModel.userInfo?.nickname ?? "", displayMode: .inline)
    }
}


struct ChatItemView: View {
    var message: ChatModel
    var body: some View {
        HStack(alignment: .center) {
            if message.userId == UserCache.shared.getUserInfo()?.userId {
                Spacer()
            }
            if message.type == 0 {
                Text(message.content)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else if message.type == 1 {
                KFImageView(message.content)
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            } else if message.type == 2 {
                if let url = URL(string: message.content) {
                    VideoPlayerView(videoURL: url)
                        .frame(height: 300)
                        .onAppear {
                            // 开始播放视频
                            let player = AVPlayer(url: url)
                            player.play()
                        }
                } else {
                    Text("加载视频...")
                }
                
            }
            
            if message.userId != UserCache.shared.getUserInfo()?.userId {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}


struct VideoPlayerView: UIViewControllerRepresentable {
    var videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No need to update the view controller in this case
    }
}



struct openChatViewViewModifier: ViewModifier {
    @State var viewModel: ChatViewModel
    @State private var isGO: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                debugPrint("去聊天")
                isGO.toggle()
            }
            .background {
                NavigationLink(destination:
                                ChatView(viewModel: viewModel),
                               isActive: $isGO) {
                }
            }
    }
}





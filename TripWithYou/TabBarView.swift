//
//  TabBarView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/18.
//


import SwiftUI

struct TabBarView: View {
    @Binding var currentTabBarType: TabBarType
    var tabbar: [TabbarModel]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0)  {
            ForEach(tabbar, id: \.name) { item in
                Spacer()
                tabBarButtonItem(tabbar: item, isSelected: currentTabBarType == item.type) {
                    currentTabBarType = item.type
                }
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .frame(maxHeight: 40)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background {
            ZStack(alignment: .top) {
                Color.white
                Divider()
            }
        }
    }
}


struct TabbarModel {
    let name: String
    let image: String
    let selectedImage: String
    let type: TabBarType
}

enum TabBarType {
    case order
    case me
    case message
    
    case announcement
    
    case trip
    
    case subscribeStatus // 查看预约状态
    case postSubscribe // 发布预约信息
    case auditTrips
    case auditTriper
    case manageAdmin
}

struct tabBarButtonItem: View {
    var tabbar :TabbarModel
    var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 8)  {
                Image(isSelected ? tabbar.selectedImage : tabbar.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(tabbar.name)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? .yellow : .gray)
        })
        .padding()
    }
}

//import SwiftUI
//
//struct TabBarView: View {
//    @Binding var currentTabBarType: TabBarType
//    var icons: [String] = ["book", "travel", "person"]
//    var names: [String] = ["订单", "导游", "我的"]
//    var types: [TabBarType] = [.order, .trip, .me]
//    var body: some View {
//        HStack(alignment: .bottom, spacing: 0)  {
//            tabBarButtonItem(TabBarIcon: icons[0], TabBarText: names[0], isSelected: currentTabBarType == types[0], action: {
//                currentTabBarType = types[0]
//            })
//            Spacer()
//            PartTabBarButtom(TabBarText: names[1], isSelected: currentTabBarType == types[1], image: icons[1], action: {
//                currentTabBarType = types[1]
//            })
//            Spacer()
//            tabBarButtonItem(TabBarIcon: icons[2], TabBarText: names[2], isSelected: currentTabBarType == types[2], action: {
//                currentTabBarType = types[2]
//            })
//        }
//        .padding(.horizontal)
//        .frame(maxHeight: 40)
//        .padding(.bottom, 30)
//        .background {
//            ZStack(alignment: .top) {
//                Color.white
//
//                Divider()
//            }
//        }
//    }
//}
//
//
//
//enum TabBarType {
//    case trip
//    case order
//    case me
//
//    case subscribeStatus // 查看预约状态
//    case postSubscribe // 发布预约信息
//
//    case auditTrips
//    case auditTriper
//    case manageAdmin
//
//    case message
//}
//
//struct tabBarButtonItem: View {
//    let TabBarIcon: String
//    let TabBarText: String
//    let isSelected: Bool
//    let action: () -> Void
//    var body: some View {
//        Button(action: {
//            action()
//        }, label: {
//            VStack(alignment: .center, spacing: 8)  {
//                Image(systemName: TabBarIcon)
//                Text(TabBarText)
//                    .font(.system(size: 12))
//            }
//            .foregroundColor(isSelected ? .yellow : .gray)
//        })
//        .padding()
//
//    }
//}
//
//struct PartTabBarButtom: View {
//    let TabBarText: String
//    let isSelected: Bool
//    var image: String = "travel"
//    let action: () -> Void
//    var body: some View {
//        Button(action: {
//            action()
//        }, label: {
//            VStack(alignment: .center, spacing: 8)  {
//                Image(image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 40)
//                Text(TabBarText)
//                    .font(.system(size: 12))
//            }
//            .foregroundColor(isSelected ? Color(red: 0.999, green: 0.779, blue: 0.311) : .gray)
//        })
//        .padding()
//    }
//}
//
//
//

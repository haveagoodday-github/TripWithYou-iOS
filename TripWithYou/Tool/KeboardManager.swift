//
//  KeboardManager.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/5/19.
//

import SwiftUI

struct keyboardExtensionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Image(systemName: "keyboard.chevron.compact.down")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                }
            }
    }
}

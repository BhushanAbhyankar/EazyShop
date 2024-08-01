//
//  Utilities.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

struct BaseButtonStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color
    let overlayColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.custom("Metropolis-Regular", size: 14).weight(.bold))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .center)
            .foregroundColor(textColor)
            .background(backgroundColor)
            .cornerRadius(24)
            .overlay (
                RoundedRectangle(cornerRadius: 24)
                    .stroke(overlayColor, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
    }
}

/// Custom Button Style for Filled Style
struct FilledStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        BaseButtonStyle(backgroundColor: Color(hex: "DB3022"), textColor: .white, overlayColor: Color(hex: "DB3022"))
            .makeBody(configuration: configuration)
    }
}

/// Custom Button Style for Outline Style
struct OutlineStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        BaseButtonStyle(backgroundColor: .clear, textColor: .black, overlayColor: .black)
            .makeBody(configuration: configuration)
    }
}

#Preview {
    VStack {
        ESButton("SIGN UP") {
            
        }
        .buttonStyle(FilledStyle())
        
        ESButton("LOGIN") {
            
        }
        .buttonStyle(OutlineStyle())
    }
}

//
//  Utilities.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

/// BaseButton Style
struct BaseButtonAndTextStyle: ButtonStyle {
    let backgroundColor: Color
    let textColor: Color
    let overlayColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.custom(Constants.Fonts.metropolisRegular, size: 14).weight(.bold))
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
        BaseButtonAndTextStyle(backgroundColor: Constants.Colors.red,
                        textColor: Constants.Colors.white,
                        overlayColor: Constants.Colors.red)
        .makeBody(configuration: configuration)
    }
}

/// Custom Button Style for Outline Style
struct OutlineStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        BaseButtonAndTextStyle(backgroundColor: Constants.Colors.clear,
                        textColor: Constants.Colors.black,
                        overlayColor: Constants.Colors.black)
        .makeBody(configuration: configuration)
    }
}

/// Base Text Style
struct BaseTextStyle: ViewModifier {
    let textColor: Color
    let customFontName: String = Constants.Fonts.metropolisRegular
    var fontSize: CGFloat
    let fontWeight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(customFontName, size: fontSize).weight(fontWeight))
            .foregroundColor(textColor)
    }
}

/// Custom Text Metropolis-Regular
struct customMetropolisFont: ViewModifier {
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var fontColor: Color
    
    func body(content: Content) -> some View {
        content.modifier(BaseTextStyle(textColor: fontColor, fontSize: fontSize, fontWeight: fontWeight))
    }
}

extension Text {
    func fontMetropolis(fontSize: CGFloat, fontWeight: Font.Weight, fontColor: Color) -> some View {
        self.modifier(customMetropolisFont(fontSize: fontSize, fontWeight: fontWeight, fontColor: fontColor))
    }
}

extension TextField {
    func fontMetropolis(fontSize: CGFloat, fontWeight: Font.Weight, fontColor: Color) -> some View {
        self.modifier(customMetropolisFont(fontSize: fontSize, fontWeight: fontWeight, fontColor: fontColor))
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
        
        Text("Test")
            .fontMetropolis(fontSize: 34, fontWeight: .bold, fontColor: Constants.Colors.redError)
        
        Text("Test")
            .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.black)
    }
    .padding()
}

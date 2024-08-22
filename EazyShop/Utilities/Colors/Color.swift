//
//  Color.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/19/24.
//

import Foundation
import SwiftUI


public extension Color {
    
    init(hex: String, opacity: Double = 1) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, opacity: opacity)
    }
    
    
    static var randomColor: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    static var blueColor: Color {
        Color(red: 0/255, green: 0/255, blue: 255/255)
    }
    
    static var redColor: Color {
        Color(red: 255/255, green: 0/255, blue: 0/255)
    }
    
    static let red = Color(hex: "DB3022")
    static let clear = Color(.clear)
    static let white = Color(.white)
    static let black = Color(hex: "222222")
    static let blackTextField = Color(hex: "#2D2D2D")
    static let lightGray = Color(hex: "9B9B9B")
    static let redError = Color(hex: "F01F0E")
    static let backgroundLightGray = Color(hex: "F9F9F9")
    
    
    
    /// method to get an sRGB(0-255) Color based on RGB(0-1.0) values
    /// - Parameters:
    ///   - rgb: red, green, and blue (0-255)
    ///   - alpha: alpha/opacity
    /// - Returns: Color for the values above
    static func convertRGB(r: Int, g: Int, b: Int, alpha: Double = 1.0) -> Color {
        return Color(red: Double(r)/255.0, green:  Double(g)/255.0, blue:  Double(b)/255.0, opacity: alpha)
    }
    
}

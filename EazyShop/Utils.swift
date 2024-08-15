//
//  Color.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

extension Color {
    /// method to get an sRGB(0-255) Color based on RGB(0-1.0) values
    /// - Parameters:
    ///   - rgb: red, green, and blue (0-255)
    ///   - alpha: alpha/opacity
    /// - Returns: Color for the values above
    public static func convertRGB(r: Int, g: Int, b: Int, alpha: Double = 1.0) -> Color {
        return Color(red: Double(r)/255.0, green:  Double(g)/255.0, blue:  Double(b)/255.0, opacity: alpha)
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

// Extension to validate email format
extension String {
    func isValidEmail() -> Bool {
        let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        let result = self.range(of: emailPattern, options: .regularExpression)
        return result != nil
    }
}

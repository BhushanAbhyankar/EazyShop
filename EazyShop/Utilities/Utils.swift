//
//  Color.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

// Extension to validate email format
extension String {
    func isValidEmail() -> Bool {
        let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        let result = self.range(of: emailPattern, options: .regularExpression)
        return result != nil
    }
}

//
//  Constants.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/5/24.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct Titles {
        static let signUpPage = "Sign up"
        static let loginPage = "Login"
        static let forgotPassword = "Forgot password"
    }
    
    struct Text {
        static let name = "Name"
        static let email = "Email"
        static let password = "Password"
        static let alreadyHaveAnAccount = "Already have an account?"
        static let forgotPassword = "Forgot your password?"
        static let confirmEmail = "Not a valid email address. Should be your\u{200B}@email.com"
        static let signUpSocials = "Or sign up with social account"
        static let newPassword = "Please, enter your email address. You will receive a link to create a new password via email."
    }
    
    struct Buttons {
        static let loginPage = "Login Page"
        static let signUp = "SIGN UP"
        static let login = "LOGIN"
        static let send = "SEND"
    }
    
    struct Fonts {
        static let metropolisRegular = "Metropolis-ExtraBold"
    }
    
    struct Colors {
        static let red = Color(hex: "DB3022")
        static let clear = Color(.clear)
        static let white = Color(.white)
        static let black = Color(hex: "222222")
        static let blackTextField = Color(hex: "#2D2D2D")
        static let lightGray = Color(hex: "9B9B9B")
        static let redError = Color(hex: "F01F0E")
        static let backgroundLightGray = Color(hex: "F9F9F9")
    }
    
    struct Images {
        static let check = "check"
        static let close = "close"
        static let rightArrow = "round-arrow_right"
        static let google = "google"
        static let facebook = "facebook"
    }
}

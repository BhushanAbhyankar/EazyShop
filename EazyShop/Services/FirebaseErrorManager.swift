//
//  FirebaseErrorManager.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/16/24.
//

import Foundation
import FirebaseAuth

class FirebaseErrorManager {
    static func getCustomErrorMessage(error: Error) -> String {
        if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
            switch errorCode {
            case .invalidEmail:
                return "Please enter a valid email address."
            case .emailAlreadyInUse:
                return "The email is already linked to an existing account."
            case .credentialAlreadyInUse:
                return "These credentials are already in use by another account."
            case .invalidCredential:
                return "The email or password is incorrect"
            // Agrega otros errores y mensajes personalizados aquí
            default:
                return error.localizedDescription
            }
        }
        return "An unexpected error occurred. Please try again."
    }
}


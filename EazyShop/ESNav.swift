//
//  ESNav.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case ESNav
    case SignUpPage
    case LoginPage
    case ForgotPasswordPage
}

struct ESNav: View {
//    @State private var navigateToSignUp: Bool = false
    @State var path: [NavigationDestination] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                Button(Constants.Buttons.login) {
                    path.append(.SignUpPage)
                }
                .buttonStyle(OutlineStyle())
                
            }
//            .navigationDestination(isPresented: $navigateToSignUp) { SignUpPage() }
            .padding()
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .ESNav:
                    ESNav()
                case .SignUpPage:
                    SignUpPage(path: $path)
                case .LoginPage:
                    LoginPage(path: $path)
                case .ForgotPasswordPage:
                    ForgotPasswordPage(path: $path)
                }
            }
        }
    }
}

#Preview {
    ESNav()
}

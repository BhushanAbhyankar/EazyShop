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
    case HomeView
}

struct ESNav: View {
//    @State private var navigateToSignUp: Bool = false
    @StateObject private var viewModel = LoginViewModel(firebaseService: FirebaseService())
    @State var path: [NavigationDestination] = []
    
    var body: some View {
            NavigationStack(path: $path) {
                ZStack {
                    Constants.Colors.backgroundLightGray
                        .edgesIgnoringSafeArea(.all)
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
                            .environmentObject(viewModel)
                    case .LoginPage:
                        LoginPage(path: $path)
                            .environmentObject(viewModel)
                    case .ForgotPasswordPage:
                        ForgotPasswordPage(path: $path)
                            .environmentObject(viewModel)
                    case .HomeView:
//                        HomeView(path: $path)
                        EazyShopTabView(path: $path)
                    }
                }
            }
        }
    }
}

#Preview {
    ESNav()
}

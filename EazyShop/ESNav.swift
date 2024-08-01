//
//  ESNav.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

struct ESNav: View {
    @State private var navigateToSignUp: Bool = false
    
    var body: some View {
        NavigationView {
            HStack {
                Button("Login Page") {
                    navigateToSignUp.toggle()
                }
                .buttonStyle(OutlineStyle())
            }
            .padding()
            .background {
                NavigationLink("", destination: SignUpPage(), isActive: $navigateToSignUp)
            }
        }
    }
}

#Preview {
    ESNav()
}

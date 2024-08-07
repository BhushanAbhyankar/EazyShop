//
//  ForgotPasswordPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/1/24.
//

import SwiftUI

struct ForgotPasswordPage: View {
    @StateObject private var viewModel = LoginViewModel()
    
    @Binding var path: [NavigationDestination]
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text(Constants.Titles.forgotPassword)
                .fontMetropolis(fontSize: 34, fontWeight: .bold, fontColor: Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 53)
            
            HStack {
                Text(Constants.Text.newPassword)
                    .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.black)
                Spacer()
            }
            
            VStack {
                VStack(alignment: .leading) {
                    Text(Constants.Text.email)
                        .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Constants.Colors.lightGray)
                        .padding(.leading, 10)
                    HStack {
                        // Email Field
                        TextField("", text: $viewModel.email)
                            .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.blackTextField)
                            .padding(.leading, 10)
                    }
                }
                .frame(height: 64)
                .background(Color.white)
                .cornerRadius(4)
                .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(viewModel.overlayColor, lineWidth: 1)
                )
                
                viewModel.errorText
                
            }
            .padding(.bottom, 39)
            
            // Sign Up Button
            ESButton(Constants.Buttons.send) {
                path.removeAll()
            }
            .buttonStyle(FilledStyle())
            
            Spacer()
            
        }
        .padding()
        .padding(.top, 18)
        .background(Constants.Colors.backgroundLightGray)
    }
}

#Preview {
    ForgotPasswordPage(path: .constant([]))
}

//
//  ForgotPasswordPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/1/24.
//

import SwiftUI

struct ForgotPasswordPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Forgot password")
                .font(.custom("Metropolis-ExtraBold", size: 34)).bold()
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 53)
            
            
            HStack {
                
                Text("Please, enter your email address. You will receive a link to create a new password via email.")
                    .font(.custom("Metropolis-Regular", size: 14))
                    .foregroundColor(.black)
                Spacer()
            }
            
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.custom("Metropolis-Regular", size: 11))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    HStack {
                        // Email Field
                        TextField("", text: $email)
                            .onChange(of: email) { newValue in
                                isValidEmail = newValue.isValidEmail()
                        }
                            .font(.custom("Metropolis-Regular", size: 14))
                            .padding(.leading, 10)
                    }
                }
                .frame(height: 64)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(isValidEmail ? Color(.systemGray4) : Color(hex: "F01F0E"), lineWidth: 2))
                
                if !isValidEmail {
                    Text("Not a valid email address. Should be your\u{200B}@email.com")
                        .font(.custom("Metropolis-Regular", size: 11))
                        .foregroundColor(Color(hex: "F01F0E"))
                        .textSelection(.disabled)
                }
                
            }
            .padding(.bottom, 39)
            
            // Sign Up Button
            ESButton("LOGIN") {
                
            }
            .buttonStyle(FilledStyle())
            
            Spacer()
            
        }
        .padding()
        .padding(.top, 18)
        .background(Color(hex: "F9F9F9"))
    }
}

#Preview {
    ForgotPasswordPage()
}

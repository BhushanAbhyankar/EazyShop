//
//  SignUpPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

struct SignUpPage: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var nextView: Bool = false
    @State private var isValidEmail: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Sign up")
                .font(.custom("Metropolis-ExtraBold", size: 34)).bold()
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 53)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.custom("Metropolis-Regular", size: 11))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    HStack {
                        // Name Field
                        TextField("", text: $name)
                            .padding(.leading, 10)
                            .font(.custom("Metropolis-Regular", size: 14))
                        
                        if !name.isEmpty {
                            Image("check")
                                .foregroundColor(.green)
                                .padding(.trailing, 8)
                        }
                    }
                }
                .frame(height: 64)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(.systemGray4), lineWidth: 2))
                
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
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.custom("Metropolis-Regular", size: 11))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    HStack {
                        // Password Field
                        SecureField("", text: $password)
                            .font(.custom("Metropolis-Regular", size: 14))
                            .padding(.leading, 10)
                    }
                }
                .frame(height: 64)
                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(.systemGray4), lineWidth: 2))
                
            }
            
            // Already have an account
            HStack {
                Spacer()
                Text("Already have an account?")
                    .font(.custom("Metropolis-Regular", size: 14))
                    .foregroundColor(.black)
                
                Button(action: {
                    nextView.toggle()
                }, label: {
                    Image("round-arrow_right")
                        .foregroundColor(.red)
                })
                
            }
            .padding(.bottom, 28)
            
            // Sign Up Button
            ESButton("SIGN UP") {
                
            }
            .buttonStyle(FilledStyle())
            
            Spacer()
            
            // Or sign up with social account
            Text("Or sign up with social account")
                .font(.custom("Metropolis-Regular", size: 14))
                .foregroundColor(.black)
                .padding(.top)
            
            // Social Buttons
            HStack(spacing: 16) {
                Button(action: {
                    // Google sign up
                }) {
                    Image("google")
                        .foregroundColor(.black)
                        .frame(width: 92, height: 64)
                        .background(Color(.white))
                        .cornerRadius(24)
                }
                
                Button(action: {
                    // Facebook sign up
                }) {
                    Image("facebook")
                        .foregroundColor(.blue)
                        .frame(width: 92, height: 64)
                        .background(Color(.white))
                        .cornerRadius(24)
                }
            }
            .padding(.top)
        }
        .padding()
        .padding(.top, 18)
        .background(Color(hex: "F9F9F9"))
        .background {
            NavigationLink("", destination: LoginPage(), isActive: $nextView)
        }
    }
}

#Preview {
    SignUpPage()
}

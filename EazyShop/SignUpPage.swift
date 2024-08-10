//
//  SignUpPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI
import FBSDKCoreKit

struct SignUpPage: View {
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject private var firebase = FirebaseService()
    @Binding var path: [NavigationDestination]
    //@State private var nextView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text(Constants.Titles.signUpPage)
                    .fontMetropolis(fontSize: 34, fontWeight: .bold, fontColor: Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 53)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(Constants.Text.name)
                            .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Constants.Colors.lightGray)
                            .padding(.leading, 10)
                        HStack {
                            // Name Field
                            TextField("", text: $viewModel.name)
                                .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.lightGray)
                                .padding(.leading, 10)
                            
                            viewModel.nameCheckImage
                        }
                    }
                    .frame(height: 64)
                    .background(Color.white)
                    .cornerRadius(4)
                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
                    
                    VStack(alignment: .leading) {
                        Text(Constants.Text.email)
                            .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Constants.Colors.lightGray)
                            .padding(.leading, 10)
                        HStack {
                            // Email Field
                            TextField("", text: $viewModel.email)
                                .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.blackTextField)
                                .padding(.leading, 10)
                                .autocapitalization(.none) // Deactivate automatic capitalized
                                .keyboardType(.emailAddress) // Keyboard for mail address
                            
                            viewModel.mailCheckImage
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
                    
                    VStack(alignment: .leading) {
                        Text(Constants.Text.password)
                            .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Constants.Colors.lightGray)
                            .padding(.leading, 10)
                        HStack {
                            // Password Field
                            SecureField("", text: $viewModel.password)
                                .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.blackTextField)
                                .padding(.leading, 10)
                        }
                    }
                    .frame(height: 64)
                    .background(Color.white)
                    .cornerRadius(4)
                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
                }
                
                // Already have an account
                HStack {
                    Spacer()
                    Text(Constants.Text.alreadyHaveAnAccount)
                        .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.black)
                    
                    Button(action: {
                        path.append(.LoginPage)
                    }, label: {
                        Image(Constants.Images.rightArrow)
                            .foregroundColor(.red)
                    })
                    
                }
                .padding(.bottom, 28)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Sign Up Button
                ESButton(Constants.Buttons.signUp) {
                    viewModel.signUp { result in
                        switch result {
                        case .success:
                            print("Registro exitoso")
                            path.append(.LoginPage)
                        case .failure(let error):
                            // Muestra el error en la interfaz de usuario
                            viewModel.errorMessage = error.localizedDescription
                        }
                    }
                }
                .buttonStyle(FilledStyle())
                .disabled(viewModel.isLoading)
                
                Spacer()
                
                // Or sign up with social account
                Text(Constants.Text.signUpSocials)
                    .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Constants.Colors.black)
                    .padding(.top)
                
                // Social Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Google sign up
                        firebase.signInWithGoogle()
                    }) {
                        Image(Constants.Images.google)
                            .frame(width: 92, height: 64)
                            .background(Constants.Colors.white)
                            .cornerRadius(24)
                    }
                    
                    Button(action: {
                        // Facebook sign up
                        firebase.signInWithFacebook()
                    }) {
                        Image(Constants.Images.facebook)
                            .frame(width: 92, height: 64)
                            .background(Constants.Colors.white)
                            .cornerRadius(24)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .padding(.top, 18)
        .background(Constants.Colors.backgroundLightGray)
        .onChange(of: firebase.isLoggedIn) { oldValue, newValue in
            if newValue {
                path.append(.HomeView)
            }
        }
        //        .navigationDestination(isPresented: $nextView) { LoginPage() }
    }
}

#Preview {
    SignUpPage(path: .constant([]))
}

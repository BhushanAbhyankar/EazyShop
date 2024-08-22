//
//  LoginPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

struct LoginPage: View {
    @EnvironmentObject private var viewModel: LoginViewModel
    @ObservedObject private var firebase = FirebaseService()
    
    @Binding var path: [NavigationDestination]
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text(TitleConstants.loginPage)
                    .fontMetropolis(fontSize: 34, fontWeight: .bold, fontColor: Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 53)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(TextConstants.email)
                            .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Color.lightGray)
                            .padding(.leading, 10)
                        HStack {
                            // Email Field
                            TextField("", text: $viewModel.email)
                                .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Color.blackTextField)
                                .padding(.leading, 10)
                                .autocapitalization(.none) // Deactivate automatic capitalized
                                .keyboardType(.emailAddress) // Keyboard for mail address
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
                        Text(TextConstants.password)
                            .fontMetropolis(fontSize: 11, fontWeight: .regular, fontColor: Color.lightGray)
                            .padding(.leading, 10)
                        HStack {
                            // Password Field
                            SecureField("", text: $viewModel.password)
                                .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Color.blackTextField)
                                .padding(.leading, 10)
                        }
                    }
                    .frame(height: 64)
                    .background(Color.white)
                    .cornerRadius(4)
                    .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 0)
                    
                }
                
                // Forgot your password?
                HStack {
                    Spacer()
                    Text(TextConstants.forgotPassword)
                        .fontMetropolis(fontSize: 14, fontWeight: .bold, fontColor: Color.black)
                    
                    Button(action: {
                        path.append(.ForgotPasswordPage)
                    }, label: {
                        Image(ImageConstants.rightArrow)
                            .foregroundColor(.red)
                    })
                    
                }
                .padding(.bottom, 28)
                
//                // Error message
//                if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
                
                // Login Button
                ESButton(ButtonConstants.login) {
                    print("Botón de inicio de sesión presionado.") // Depuración
                    
                    firebase.login(email: viewModel.email, password: viewModel.password) { result in
                        switch result {
                        case .success:
                            viewModel.errorMessage = "Login successful."
                            viewModel.showAlert = true
                            viewModel.isLoggedIn = true
                            print("Navegando a HomeView...") // Depuración
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)") // Depuración
                            viewModel.errorMessage = error.localizedDescription
                            viewModel.showAlert = true
                            viewModel.isLoggedIn = false
                            print("Login fail")
                        }
                    }
                }
                .buttonStyle(FilledStyle())
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                
                Spacer()
                
                // Or sign up with social account
                Text(TextConstants.signUpSocials)
                    .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Color.black)
                    .padding(.top)
                
                // Social Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Google sign up
                        viewModel.signInWithGoogle()
                    }) {
                        Image(ImageConstants.google)
                            .frame(width: 92, height: 64)
                            .background(Color.white)
                            .cornerRadius(24)
                    }
                    
                    Button(action: {
                        // Facebook sign up
                        viewModel.signInWithFacebook()
                    }) {
                        Image(ImageConstants.facebook)
                            .frame(width: 92, height: 64)
                            .background(Color.white)
                            .cornerRadius(24)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .padding(.top, 18)
        .background(Color.backgroundLightGray)
        .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text("Login"),
                        message: Text(viewModel.errorMessage ?? ""),
                        dismissButton: .default(Text("OK")) {
                            if viewModel.isLoggedIn {
                                path.append(.HomeView)
                            }
                        }
                    )
                }
//        .onChange(of: firebase.isLoggedIn) { oldValue, newValue in
//            if newValue {
//                path.append(.HomeView)
//            }
//        }
        
        //        .navigationDestination(isPresented: $nextView) { ForgotPasswordPage() }
        //        .navigationDestination(isPresented: $nextView2) { ESNav() }
    }
}

#Preview {
    LoginPage(path: .constant([]))
        .environmentObject(LoginViewModel(firebaseService: FirebaseService()))
}

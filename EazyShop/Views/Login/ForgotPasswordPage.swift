//
//  ForgotPasswordPage.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/1/24.
//

import SwiftUI

struct ForgotPasswordPage: View {
    @EnvironmentObject private var viewModel: LoginViewModel
    
    @Binding var path: [NavigationDestination]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Title
                Text(TitleConstants.forgotPassword)
                    .fontMetropolis(fontSize: 34, fontWeight: .bold, fontColor: Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 53)
                
                HStack {
                    Text(TextConstants.newPassword)
                        .fontMetropolis(fontSize: 14, fontWeight: .regular, fontColor: Color.black)
                    Spacer()
                }
                
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
                    
                }
                .padding(.bottom, 39)
                
//                if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
                
                // Sign Up Button
                ESButton(ButtonConstants.send) {
                    viewModel.resetPassword { result in
                        switch result {
                        case .success:
                            // Acciones si el enlace fue enviado exitosamente
                            print("Reset password mail sent") // Depuración
                            //path.removeAll() // Navegar a la pantalla principal
                        case .failure(let error):
                            // Manejar el error si es necesario
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                .buttonStyle(FilledStyle())
                
                Spacer()
            }
        }
        .padding()
        .padding(.top, 18)
        .background(Color.backgroundLightGray)
        .alert(isPresented: $viewModel.showResetAlert) {
                    Alert(
                        title: Text("Password reset"),
                        message: Text(viewModel.errorMessage ?? ""),
                        dismissButton: .default(Text("OK")) {
                            
                                path.removeLast()
                            
                        }
                    )
                }
    }
}

#Preview {
    ForgotPasswordPage(path: .constant([]))
        .environmentObject(LoginViewModel(firebaseService: FirebaseService()))
}

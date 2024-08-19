//
//  LoginViewModel.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/5/24.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth


class LoginViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValidEmail: Bool = true
    @Published var hasStartedTyping: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var showResetAlert: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isSignedIn: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var firebaseService: FireBaseServiceActions
    
    init(firebaseService: FireBaseServiceActions) {
        self.firebaseService = firebaseService
        
        self.$email
            .sink { [weak self] newValue in
                self?.isValidEmail = newValue.isValidEmail()
                if !newValue.isEmpty {
                    self?.hasStartedTyping = true
                }
            }
            .store(in: &cancellables)
    }
    
    
    func signUp(completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        firebaseService.signUp(name: name, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                completion(result)
            }
        }
    }
    
    func signInWithFacebook() {
        firebaseService.signInWithFacebook { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.errorMessage = "Successful Facebook login."
                case .failure(let error):
                    if let errorCode = AuthErrorCode(rawValue: (error as NSError).code), errorCode == .accountExistsWithDifferentCredential {
                        self?.errorMessage = "An account with this email already exists but with different credentials. Please use the appropriate provider to sign in."
                    } else {
                        self?.errorMessage = "Error logging in with Facebook: \(error.localizedDescription)"
                    }
                    self?.isLoggedIn = false // Do not navigate to HomeView
                }
                self?.showAlert = true
            }
        }
    }

    func signInWithGoogle() {
        firebaseService.signInWithGoogle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isLoggedIn = true
                    self?.errorMessage = "Successful Google login."
                case .failure(let error):
                    if let errorCode = AuthErrorCode(rawValue: (error as NSError).code), errorCode == .accountExistsWithDifferentCredential {
                        self?.errorMessage = "An account with this email already exists but with different credentials. Please use the appropriate provider to sign in."
                    } else {
                        self?.errorMessage = "Error logging in with Google: \(error.localizedDescription)"
                    }
                    self?.isLoggedIn = false // Do not navigate to HomeView
                }
                self?.showAlert = true
            }
        }
    }

    
    func resetPassword(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !email.isEmpty else {
            self.errorMessage = "Mail cannot be empty."
            return
        }
        
        // Verify if mail exist in DB
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(email)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                // Si el documento existe, enviamos el correo de restablecimiento
                Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                    if let error = error {
                        self.errorMessage = "Fail to send link: \(error.localizedDescription)"
                        completion(.failure(error))
                        
                    } else {
                        self.errorMessage = "A link to reset password has been sent."
                        completion(.success(()))
                    }
                }
            } else {
                // Si el documento no existe, mostramos un mensaje de error
                self.errorMessage = "There is any user with this email account."
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "There is any user with this email account."])))
            }
//            DispatchQueue.main.async {
                self.showResetAlert = true
//            }
        }
    }
    
    var errorText: some View {
        if hasStartedTyping && !isValidEmail {
            return AnyView(
                Text(Constants.Text.confirmEmail)
                    .font(.custom(Constants.Fonts.metropolisRegular, size: 11))
                    .foregroundColor(Constants.Colors.redError)
                    .textSelection(.disabled)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var overlayColor: Color {
        if hasStartedTyping {
            return isValidEmail ? Color(.clear) : Constants.Colors.redError
        } else {
            return Color(.clear)
        }
    }
    
    var nameCheckImage: some View {
        if !name.isEmpty {
            return AnyView(
                Image(Constants.Images.check)
                    .foregroundColor(.green)
                    .padding(.trailing, 8)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var mailCheckImage: some View {
        if hasStartedTyping && !isValidEmail {
            return AnyView(
                Image(Constants.Images.close)
                    .foregroundColor(.red)
                    .padding(.trailing, 8)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}


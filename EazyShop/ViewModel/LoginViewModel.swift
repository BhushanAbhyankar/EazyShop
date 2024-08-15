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

//class fakeServiceManager: FireBaseServiceActions {
//    func login(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
//        //completion {
//    }
//    
//    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void) {
//        <#code#>
//    }
//    
//    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func addUserToDatabase(name: String, email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func fetchUser(email: String, completion: @escaping (Result<[String : Any], any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func signInWithFacebook() {
//        <#code#>
//    }
//    
//    func signInWithGoogle() {
//        <#code#>
//    }
//    
//    
//}


class LoginViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValidEmail: Bool = true
    @Published var hasStartedTyping: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
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


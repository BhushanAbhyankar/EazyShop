//
//  FirebaseService.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/6/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FacebookLogin
import FBSDKCoreKit
import GoogleSignIn

protocol FireBaseServiceActions {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void)
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func addUserToDatabase(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUser(email: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    func signInWithFacebook(completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void)
}

class FirebaseService: ObservableObject, FireBaseServiceActions {
    private let auth = Auth.auth()  // Inicializa la instancia de autenticación
    private let db = Firestore.firestore()  // Inicializa la instancia de Firestore
    
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
            print("Attempting to log in with email: \(email)") // Debbuging

            // Iniciar sesión con Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Authentication error: \(error.localizedDescription)") // Debbuging
                    // Use the FirebaseManager to get a custom error message
                    let customErrorMessage = FirebaseErrorManager.getCustomErrorMessage(error: error)
                    // Create a new error with the custom message and return it
                    let customError = NSError(domain: "Login Error", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey : customErrorMessage])
                    completion(.failure(customError))
                    return
                }

                // Verificar si el usuario existe en Firestore
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(email)

                docRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching document \(error.localizedDescription)") // Debbuging
                        // Use the FirebaseErrorManager to get a custom error message
                        let customErrorMessage = FirebaseErrorManager.getCustomErrorMessage(error: error)
                        // Create a new error with the custom message and return it
                        let customError = NSError(domain: "FirestoreError", code: (error as NSError).code, userInfo: [NSLocalizedDescriptionKey: customErrorMessage])
                        completion(.failure(customError))
                    } else if let document = document, document.exists {
                        print("User found in Firestore, logging in...") // Debbuging
                        completion(.success(()))
                    } else {
                        print("User not found in Firestore.") // Debugging
                        let customErrorMessage = "User not found in the database."
                        let customError = NSError(domain: "LoginError", code: 404, userInfo: [NSLocalizedDescriptionKey: customErrorMessage])
                        completion(.failure(customError))
                    }
                }
            }
        }
    
    /// Func to verify if the mail is already in use.
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Create user after sign up and save it to database.
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Validar campos vacíos
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            completion(.failure(NSError(domain: "SignUpError", code: 400, userInfo: [NSLocalizedDescriptionKey: "All fields are required."])))
            return
        }
        
        // Crear el usuario en Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                // Agregar usuario a la base de datos
                self.addUserToDatabase(name: name, email: email, password: password) { result in
                    completion(result)
                }
            }
        }
    }
    
    /// Private function to add a user to Firestore.
    func addUserToDatabase(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let user = ["name": name, "email": email, "password": password]
        
        db.collection("users").document(email).setData(user) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Func to read data from a Firestore user
    func fetchUser(email: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(email).getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data() {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "UnknownError", code: -1, userInfo: nil)))
            }
        }
    }
    
//    /// Func to update data of a Firebase user
//    func updateUser(email: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
//        db.collection("users").document(email).updateData(newData) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
    
//    /// Func to delete a user from Firestore
//    func deleteUser(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        db.collection("users").document(email).delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
    
    /// Sign in with Facebook
    func signInWithFacebook(completion: @escaping (Result<Void, Error>) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result, !result.isCancelled else {
                let cancellationError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login cancelled."])
                completion(.failure(cancellationError))
                return
            }
            
            guard let tokenString = AccessToken.current?.tokenString else {
                let tokenError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "An access token was not obtained."])
                completion(.failure(tokenError))
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Inicio de sesión exitoso
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    completion(.success(()))
                }
            }
        }
    }

    func signInWithGoogle(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                let resultError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result was obtained from the Google sign-in."])
                completion(.failure(resultError))
                return
            }
            
            guard let idToken = result.user.idToken?.tokenString else {
                let tokenError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The Google ID token could not be retrieved."])
                completion(.failure(tokenError))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    completion(.success(()))
                }
            }
        }
    }
}

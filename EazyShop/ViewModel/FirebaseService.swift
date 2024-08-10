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
import GoogleSignIn

class FirebaseService: ObservableObject {
    private let auth = Auth.auth()  // Inicializa la instancia de autenticación
    private let db = Firestore.firestore()  // Inicializa la instancia de Firestore
    
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
            print("Intentando iniciar sesión con email: \(email)") // Depuración

            // Iniciar sesión con Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Error de autenticación: \(error.localizedDescription)") // Depuración
                    completion(.failure(error))
                    return
                }

                // Verificar si el usuario existe en Firestore
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(email)

                docRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error al obtener el documento: \(error.localizedDescription)") // Depuración
                        completion(.failure(error))
                    } else if let document = document, document.exists {
                        print("Usuario encontrado en Firestore, iniciando sesión...") // Depuración
                        completion(.success(()))
                    } else {
                        print("Usuario no encontrado en Firestore.") // Depuración
                        completion(.failure(NSError(domain: "LoginError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Usuario no encontrado en la base de datos."])))
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
            completion(.failure(NSError(domain: "SignUpError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Todos los campos son requeridos."])))
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
    private func addUserToDatabase(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    /// Func to update data of a Firebase user
    func updateUser(email: String, newData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(email).updateData(newData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Func to delete a user from Firestore
    func deleteUser(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(email).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Sign in with Facebook
    func signInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { result in
            switch result {
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Error en el inicio de sesión con Facebook: \(error.localizedDescription)")
                        return
                    }
                    // Inicio de sesión exitoso
                    print("Inicio de sesión con Facebook exitoso.")
                    // Aquí puedes manejar la navegación o el estado del usuario después de un login exitoso
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                }
            case .cancelled:
                print("Inicio de sesión cancelado.")
            case .failed(let error):
                print("Error en el inicio de sesión con Facebook: \(error.localizedDescription)")
            }
        }
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Error en el inicio de sesión con Google: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No se obtuvo resultado del inicio de sesión de Google.")
                return
            }
            
            guard let idToken = result.user.idToken?.tokenString else {
                print("No se pudo obtener el ID token de Google.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error en el inicio de sesión con Google: \(error.localizedDescription)")
                    return
                }
                print("Inicio de sesión con Google exitoso.")
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            }
        }
    }
}

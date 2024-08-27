//
//  AppDelegate.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/9/24.
//

import SwiftUI
import FBSDKCoreKit
import GoogleSignIn
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Firebase
        FirebaseApp.configure()
        
        // Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Manage Facebook & Google URL
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }
        return GIDSignIn.sharedInstance.handle(url)
    }
}

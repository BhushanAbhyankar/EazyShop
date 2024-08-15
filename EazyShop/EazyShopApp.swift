//
//  EazyShopApp.swift
//  EazyShop
//
//  Created by Bhushan Abhyankar on 31/07/2024.
//

import SwiftUI
import SwiftData

@main
struct EazyShopApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        if let facebookAppID = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String {
            print("Facebook App ID: \(facebookAppID)")
        } else {
            print("Facebook App ID not found in Info.plist")
        }
    }

    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ESNav()
        }
        .modelContainer(sharedModelContainer)
    }
}

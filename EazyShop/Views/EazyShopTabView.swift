//
//  EazyShopTabView.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/19/24.
//

import SwiftUI

struct EazyShopTabView: View {
    
    @Binding var path: [NavigationDestination]
    
    var body: some View {
        TabView {
            NavigationStack {
                EazyShopHomeView()
                    .navigationTitle("Home")
            }
            .tabItem {
                //Label("Home", systemImage: "1.circle")
                Text("Home")
                Image(systemName: "house.circle.fill")
                    .renderingMode(.template)
            }
            
            ShoppingView()
                .tabItem {
                    Text("Shop")
                    Image(systemName: "cart.fill")
                }
            
           CartView()
                .tabItem {
                    Text("Bag")
                    Image(systemName: "bag.fill")
                }
            FavoritesView()
                .tabItem {
//                    Label("Tab 4", systemImage: "4.circle")
                    Text("Favorites")
                    Image(systemName: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(Color.red)
                .onAppear(perform: {
                    //2
//                    UITabBar.appearance().unselectedItemTintColor = .systemBrown
                    UITabBar.appearance().unselectedItemTintColor = .systemGray
                    //3
                    UITabBarItem.appearance().badgeColor = UIColor(Color.red)
//                    UITabBarItem.appearance().badgeColor = .systemPink
                    //4
                    UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
                    //5
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.red)]
//                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
                    //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                    //Above API will kind of override other behaviour and bring the default UI for TabView
                })
    }
}

#Preview {
    EazyShopTabView(path: .constant([]))
}

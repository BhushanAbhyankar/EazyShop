//
//  HomeView.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/9/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var path: [NavigationDestination]
    
    var body: some View {
        ZStack {
            Constants.Colors.backgroundLightGray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("WELCOME TO")
                    .fontMetropolis(fontSize: 35, fontWeight: .bold, fontColor: Constants.Colors.black)
                Text("EazyShop")
                    .fontMetropolis(fontSize: 70, fontWeight: .bold, fontColor: Constants.Colors.red)
            }
            .background(Constants.Colors.backgroundLightGray)
        }
    }
}

#Preview {
    HomeView(path: .constant([]))
}

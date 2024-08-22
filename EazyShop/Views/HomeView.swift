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
            Color.backgroundLightGray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("WELCOME TO")
                    .fontMetropolis(fontSize: 35, fontWeight: .bold, fontColor: Color.black)
                Text("EazyShop")
                    .fontMetropolis(fontSize: 70, fontWeight: .bold, fontColor: Color.red)
            }
            .background(Color.backgroundLightGray)
        }
    }
}

#Preview {
    HomeView(path: .constant([]))
}

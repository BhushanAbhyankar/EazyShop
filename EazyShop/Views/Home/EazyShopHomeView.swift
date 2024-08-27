//
//  EazyShopHomeView.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/19/24.
//

import SwiftUI

struct EazyShopHomeView: View {
    @StateObject var productsViewModel = ProductsViewModel()
    
    var body: some View {
        NavigationStack {
            ProductListView()
        }
    }
}

#Preview {
    EazyShopHomeView()
}

//
//  ProductDetailsView.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import SwiftUI

struct ProductDetailsView: View {
    
    var product: ProductElement
    
    var body: some View {
        Text("Details For Product!")
    }
}

#Preview {
    ProductDetailsView(product: ProductElement(id: 1, title: "prod1", description: "", category: Category(rawValue: "")!, price: 100.00, discountPercentage: 10.00, rating: 5.00, stock: 1000, thumbnail: ""))
}

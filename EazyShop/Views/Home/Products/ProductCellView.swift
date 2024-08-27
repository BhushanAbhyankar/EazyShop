//
//  ProductCellView.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import SwiftUI

struct ProductCellView: View {
    
    var product: ProductElement
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                
            } placeholder: {
                ProgressView()
                    .frame(width: 250, height: 250)
            }
            
            Text(product.title)
                .font(.title)
            //        Text(product.price)
        }
    }
}

#Preview {
    ProductCellView(product: ProductElement(id: 1, title: "prod1", description: "", category: Category(rawValue: "")!, price: 100.00, discountPercentage: 10.00, rating: 5.00, stock: 1000, thumbnail: ""))
}

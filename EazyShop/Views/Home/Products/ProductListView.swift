//
//  ProductListView.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var productsViewModel = ProductsViewModel()
    
    var body: some View {
//        NavigationStack {
            VStack {
                switch productsViewModel.productViewState {
                  case .loading:
                    ProgressView()
                case .load(let product):
                    List(product.products) {product in
                        NavigationLink(
                            destination: ProductDetailsView(product: product),
                            label: {
                                ProductCellView(product: product)
                            })
                        Text(product.title)
                    }
                case .error(let error):
                    Text(error)
                }
            }
            .padding()
//        }
        .task {
           await productsViewModel.getProducts()
        }
    }
}

#Preview {
    ProductListView()
}

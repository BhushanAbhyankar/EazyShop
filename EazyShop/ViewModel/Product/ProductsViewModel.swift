//
//  ProductsViewModel.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import Foundation


enum ProductViewState {
    case loading
    case load(Product)
    case error(String)
}



final class ProductsViewModel: ObservableObject {
    
    private let networkManager: NetworkManagerActions
    
    @Published var productViewState = ProductViewState.loading
    
    init(networkManager: NetworkManagerActions = NetworkManager()) {
        self.networkManager = networkManager
    }
}



extension ProductsViewModel {
    
    
    @MainActor
    func getProducts() async {
        do {
            let products =  try await networkManager.get(url:APIConstants.ProductsBaseURL + APIConstants.ProductsEndpoint, modelType: Product.self)
            productViewState = .load(products)
        }catch {
            productViewState = .error(error.localizedDescription)
        }
    }
}



//
//  NetworkManager.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import Foundation


protocol NetworkManagerActions {
    
    func get<T: Decodable>(url: String, modelType: T.Type)async throws -> T
    
}


struct NetworkManager: NetworkManagerActions {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
}



extension NetworkManager {
    
    func get<T>(url: String, modelType: T.Type) async throws -> T where T : Decodable {
        
        guard let urlObj = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: urlObj)
                
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        return try JSONDecoder().decode(modelType, from: data)
    }
    
}

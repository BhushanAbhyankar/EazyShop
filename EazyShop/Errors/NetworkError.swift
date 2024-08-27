//
//  NetworkError.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import Foundation


enum NetworkError: Error {
    
    case invalidURL
    case invalidResponse(Int)
    
}


extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return APIStrings.InvalidURLString
        case .invalidResponse(let statusCode):
            return APIStrings.InvalidURLString + "with status code \(statusCode)"
        }
    }
    
}

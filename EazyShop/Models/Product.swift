//
//  Product.swift
//  EazyShop
//
//  Created by Ebillson Grand Jean on 8/27/24.
//

import Foundation


// MARK: - Product
struct Product: Decodable {
    let products: [ProductElement]
    let total, skip, limit: Int
}

// MARK: - ProductElement
struct ProductElement: Decodable, Identifiable {
    let id: Int
    let title, description: String
    let category: Category
    let price, discountPercentage, rating: Double
    let stock: Int
//    let tags: [String]
//    let brand: String?
//    let sku: String
//    let weight: Int
//    let dimensions: Dimensions
//    let warrantyInformation, shippingInformation: String
//    let availabilityStatus: AvailabilityStatus
//    let reviews: [Review]
//    let returnPolicy: ReturnPolicy
//    let minimumOrderQuantity: Int
//    let meta: Meta
//    let images: [String]
    let thumbnail: String
}

enum AvailabilityStatus: String, Decodable {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
}

enum Category: String, Decodable {
    case beauty = "beauty"
    case fragrances = "fragrances"
    case furniture = "furniture"
    case groceries = "groceries"
}


// MARK: - Dimensions
struct Dimensions: Decodable {
    let width, height, depth: Double
}

// MARK: - Meta
struct Meta: Decodable {
    let createdAt, updatedAt: CreatedAt
    let barcode: String
    let qrCode: String
}

enum CreatedAt: String, Decodable {
    case the20240523T085621618Z = "2024-05-23T08:56:21.618Z"
    case the20240523T085621619Z = "2024-05-23T08:56:21.619Z"
    case the20240523T085621620Z = "2024-05-23T08:56:21.620Z"
}

enum ReturnPolicy: String, Decodable {
    case noReturnPolicy = "No return policy"
    case the30DaysReturnPolicy = "30 days return policy"
    case the60DaysReturnPolicy = "60 days return policy"
    case the7DaysReturnPolicy = "7 days return policy"
    case the90DaysReturnPolicy = "90 days return policy"
}

// MARK: - Review
struct Review: Decodable {
    let rating: Int
    let comment: String
    let date: CreatedAt
    let reviewerName, reviewerEmail: String
}




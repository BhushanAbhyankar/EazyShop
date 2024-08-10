//
//  Item.swift
//  EazyShop
//
//  Created by Bhushan Abhyankar on 31/07/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

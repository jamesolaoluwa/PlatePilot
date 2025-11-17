//
//  GroceryItem.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct GroceryItem {
    var id: UUID
    var name: String
    var quantity: String
    var category: String
    var isPurchased: Bool
    
    init(id: UUID = UUID(), name: String, quantity: String, category: String, isPurchased: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.isPurchased = isPurchased
    }
}

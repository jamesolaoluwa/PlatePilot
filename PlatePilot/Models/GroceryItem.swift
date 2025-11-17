//
//  GroceryItem.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct GroceryItem: Codable, Equatable {
    var id: String
    var name: String
    var quantityDescription: String
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, name: String, quantityDescription: String, isCompleted: Bool = false) {
        self.id = id
        self.name = name
        self.quantityDescription = quantityDescription
        self.isCompleted = isCompleted
    }
}

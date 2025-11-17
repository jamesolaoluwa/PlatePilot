//
//  Meal.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct Ingredient: Codable, Equatable {
    var name: String
    var quantityDescription: String
    var isCheckedForGrocery: Bool
    
    init(name: String, quantityDescription: String, isCheckedForGrocery: Bool = false) {
        self.name = name
        self.quantityDescription = quantityDescription
        self.isCheckedForGrocery = isCheckedForGrocery
    }
}

struct Meal: Codable, Equatable {
    var id: String
    var name: String
    var imageURL: String?
    var instructions: String
    var ingredients: [Ingredient]
    var calories: Int
    var estimatedCost: Double
    var cookTimeMinutes: Int
    var isFavorite: Bool
    
    init(id: String, name: String, imageURL: String? = nil, instructions: String, ingredients: [Ingredient], calories: Int = 0, estimatedCost: Double = 0.0, cookTimeMinutes: Int = 0, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.instructions = instructions
        self.ingredients = ingredients
        self.calories = calories
        self.estimatedCost = estimatedCost
        self.cookTimeMinutes = cookTimeMinutes
        self.isFavorite = isFavorite
    }
    
    // MARK: - Convenience Properties
    
    var caloriesLabelText: String {
        return "\(calories) cal"
    }
    
    var costLabelText: String {
        return String(format: "$%.2f", estimatedCost)
    }
    
    var cookTimeLabelText: String {
        return "\(cookTimeMinutes) min"
    }
}

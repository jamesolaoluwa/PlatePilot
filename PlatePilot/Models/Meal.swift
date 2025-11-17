//
//  Meal.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct Meal {
    var id: UUID
    var name: String
    var description: String
    var ingredients: [String]
    var instructions: String
    var prepTime: Int // in minutes
    var servings: Int
    var imageURL: String?
    
    init(id: UUID = UUID(), name: String, description: String, ingredients: [String], instructions: String, prepTime: Int, servings: Int, imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.prepTime = prepTime
        self.servings = servings
        self.imageURL = imageURL
    }
}

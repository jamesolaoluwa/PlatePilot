//
//  PlannerDay.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

enum DayOfWeek: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var shortName: String {
        return String(rawValue.prefix(3))
    }
}

struct PlannerDay: Codable, Equatable {
    var id: String
    var date: Date
    var dayOfWeek: DayOfWeek
    var meals: [Meal]
    
    init(id: String = UUID().uuidString, date: Date, dayOfWeek: DayOfWeek, meals: [Meal] = []) {
        self.id = id
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.meals = meals
    }
    
    // MARK: - Convenience Properties
    
    var dayLabel: String {
        return dayOfWeek.rawValue
    }
    
    var totalCalories: Int {
        return meals.reduce(0) { $0 + $1.calories }
    }
    
    var totalCost: Double {
        return meals.reduce(0) { $0 + $1.estimatedCost }
    }
}

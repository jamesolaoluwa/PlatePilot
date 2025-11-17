//
//  PlannerDay.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct PlannerDay {
    var id: UUID
    var date: Date
    var breakfast: Meal?
    var lunch: Meal?
    var dinner: Meal?
    var snacks: [Meal]
    
    init(id: UUID = UUID(), date: Date, breakfast: Meal? = nil, lunch: Meal? = nil, dinner: Meal? = nil, snacks: [Meal] = []) {
        self.id = id
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.snacks = snacks
    }
}

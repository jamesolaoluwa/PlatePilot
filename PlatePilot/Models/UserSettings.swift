//
//  UserSettings.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

struct UserSettings: Codable {
    var weeklyBudget: Double
    var calorieGoal: Int
    var notificationsEnabled: Bool
    
    init(weeklyBudget: Double = 50.0, calorieGoal: Int = 2000, notificationsEnabled: Bool = false) {
        self.weeklyBudget = weeklyBudget
        self.calorieGoal = calorieGoal
        self.notificationsEnabled = notificationsEnabled
    }
    
    // MARK: - Convenience Properties
    
    var weeklyBudgetText: String {
        return String(format: "$%.2f", weeklyBudget)
    }
    
    var calorieGoalText: String {
        return "\(calorieGoal) cal/day"
    }
}

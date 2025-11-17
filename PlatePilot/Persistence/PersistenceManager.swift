//
//  PersistenceManager.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

class PersistenceManager {
    
    static let shared = PersistenceManager()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Keys
    
    private enum Keys {
        static let favorites = "favorites"
        static let plannerDays = "plannerDays"
        static let groceryItems = "groceryItems"
        static let userSettings = "userSettings"
    }
    
    // MARK: - Favorites
    
    /// Save favorite meals to UserDefaults
    func saveFavorites(_ favorites: [Meal]) {
        guard let data = try? encoder.encode(favorites) else {
            print("Failed to encode favorites")
            return
        }
        defaults.set(data, forKey: Keys.favorites)
    }
    
    /// Load favorite meals from UserDefaults
    func loadFavorites() -> [Meal] {
        guard let data = defaults.data(forKey: Keys.favorites),
              let favorites = try? decoder.decode([Meal].self, from: data) else {
            return []
        }
        return favorites
    }
    
    // MARK: - Planner
    
    /// Save planner days to UserDefaults
    func savePlannerDays(_ days: [PlannerDay]) {
        guard let data = try? encoder.encode(days) else {
            print("Failed to encode planner days")
            return
        }
        defaults.set(data, forKey: Keys.plannerDays)
    }
    
    /// Load planner days from UserDefaults
    func loadPlannerDays() -> [PlannerDay] {
        guard let data = defaults.data(forKey: Keys.plannerDays),
              let days = try? decoder.decode([PlannerDay].self, from: data) else {
            return []
        }
        return days
    }
    
    // MARK: - Grocery
    
    /// Save grocery items to UserDefaults
    func saveGroceryItems(_ items: [GroceryItem]) {
        guard let data = try? encoder.encode(items) else {
            print("Failed to encode grocery items")
            return
        }
        defaults.set(data, forKey: Keys.groceryItems)
    }
    
    /// Load grocery items from UserDefaults
    func loadGroceryItems() -> [GroceryItem] {
        guard let data = defaults.data(forKey: Keys.groceryItems),
              let items = try? decoder.decode([GroceryItem].self, from: data) else {
            return []
        }
        return items
    }
    
    // MARK: - User Settings
    
    /// Save user settings to UserDefaults
    func saveUserSettings(_ settings: UserSettings) {
        guard let data = try? encoder.encode(settings) else {
            print("Failed to encode user settings")
            return
        }
        defaults.set(data, forKey: Keys.userSettings)
    }
    
    /// Load user settings from UserDefaults
    func loadUserSettings() -> UserSettings {
        guard let data = defaults.data(forKey: Keys.userSettings),
              let settings = try? decoder.decode(UserSettings.self, from: data) else {
            return UserSettings() // Return default settings
        }
        return settings
    }
    
    // MARK: - Clear Data
    
    /// Clear all persisted data (useful for testing or reset)
    func clearAllData() {
        defaults.removeObject(forKey: Keys.favorites)
        defaults.removeObject(forKey: Keys.plannerDays)
        defaults.removeObject(forKey: Keys.groceryItems)
        defaults.removeObject(forKey: Keys.userSettings)
    }
}

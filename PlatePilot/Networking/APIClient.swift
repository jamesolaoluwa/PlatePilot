//
//  APIClient.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        }
    }
}

class APIClient {
    
    static let shared = APIClient()
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - API Response Models
    
    private struct MealDBResponse: Codable {
        let meals: [MealDBMeal]?
    }
    
    private struct MealDBMeal: Codable {
        let idMeal: String
        let strMeal: String
        let strMealThumb: String?
        let strInstructions: String?
        let strIngredient1: String?
        let strIngredient2: String?
        let strIngredient3: String?
        let strIngredient4: String?
        let strIngredient5: String?
        let strIngredient6: String?
        let strIngredient7: String?
        let strIngredient8: String?
        let strIngredient9: String?
        let strIngredient10: String?
        let strIngredient11: String?
        let strIngredient12: String?
        let strIngredient13: String?
        let strIngredient14: String?
        let strIngredient15: String?
        let strIngredient16: String?
        let strIngredient17: String?
        let strIngredient18: String?
        let strIngredient19: String?
        let strIngredient20: String?
        let strMeasure1: String?
        let strMeasure2: String?
        let strMeasure3: String?
        let strMeasure4: String?
        let strMeasure5: String?
        let strMeasure6: String?
        let strMeasure7: String?
        let strMeasure8: String?
        let strMeasure9: String?
        let strMeasure10: String?
        let strMeasure11: String?
        let strMeasure12: String?
        let strMeasure13: String?
        let strMeasure14: String?
        let strMeasure15: String?
        let strMeasure16: String?
        let strMeasure17: String?
        let strMeasure18: String?
        let strMeasure19: String?
        let strMeasure20: String?
    }
    
    // MARK: - Public Methods
    
    /// Search for meals by name
    /// - Parameters:
    ///   - query: Search query string
    ///   - completion: Result callback with array of Meal objects or Error
    func searchMeals(query: String, completion: @escaping (Result<[Meal], APIError>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/search.php?s=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            self?.decodeMeals(from: data, completion: completion)
        }
        
        task.resume()
    }
    
    /// Fetch random meals from the API
    /// - Parameters:
    ///   - count: Number of random meals to fetch
    ///   - completion: Result callback with array of Meal objects or Error
    func fetchRandomMeals(count: Int = 10, completion: @escaping (Result<[Meal], APIError>) -> Void) {
        var meals: [Meal] = []
        let group = DispatchGroup()
        var hasError: APIError?
        
        for _ in 0..<count {
            group.enter()
            fetchRandomMeal { result in
                switch result {
                case .success(let meal):
                    meals.append(meal)
                case .failure(let error):
                    hasError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = hasError {
                completion(.failure(error))
            } else {
                completion(.success(meals))
            }
        }
    }
    
    /// Fetch a single random meal
    /// - Parameter completion: Result callback with Meal object or Error
    func fetchRandomMeal(completion: @escaping (Result<Meal, APIError>) -> Void) {
        let urlString = "\(baseURL)/random.php"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            self?.decodeMeals(from: data) { result in
                switch result {
                case .success(let meals):
                    if let meal = meals.first {
                        completion(.success(meal))
                    } else {
                        completion(.failure(.noData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Helpers
    
    private func decodeMeals(from data: Data, completion: (Result<[Meal], APIError>) -> Void) {
        do {
            let response = try JSONDecoder().decode(MealDBResponse.self, from: data)
            
            guard let mealDBMeals = response.meals else {
                completion(.success([]))
                return
            }
            
            let meals = mealDBMeals.map { convertToMeal($0) }
            completion(.success(meals))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    
    private func convertToMeal(_ mealDB: MealDBMeal) -> Meal {
        let ingredients = extractIngredients(from: mealDB)
        
        // Estimate calories and cost based on number of ingredients
        // In a real app, this would come from a nutrition database
        let estimatedCalories = ingredients.count * 50 + Int.random(in: 100...300)
        let estimatedCost = Double(ingredients.count) * 1.5 + Double.random(in: 2...8)
        let cookTime = Int.random(in: 15...60)
        
        return Meal(
            id: mealDB.idMeal,
            name: mealDB.strMeal,
            imageURL: mealDB.strMealThumb,
            instructions: mealDB.strInstructions ?? "No instructions available.",
            ingredients: ingredients,
            calories: estimatedCalories,
            estimatedCost: estimatedCost,
            cookTimeMinutes: cookTime,
            isFavorite: false
        )
    }
    
    private func extractIngredients(from mealDB: MealDBMeal) -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        let ingredientPairs: [(String?, String?)] = [
            (mealDB.strIngredient1, mealDB.strMeasure1),
            (mealDB.strIngredient2, mealDB.strMeasure2),
            (mealDB.strIngredient3, mealDB.strMeasure3),
            (mealDB.strIngredient4, mealDB.strMeasure4),
            (mealDB.strIngredient5, mealDB.strMeasure5),
            (mealDB.strIngredient6, mealDB.strMeasure6),
            (mealDB.strIngredient7, mealDB.strMeasure7),
            (mealDB.strIngredient8, mealDB.strMeasure8),
            (mealDB.strIngredient9, mealDB.strMeasure9),
            (mealDB.strIngredient10, mealDB.strMeasure10),
            (mealDB.strIngredient11, mealDB.strMeasure11),
            (mealDB.strIngredient12, mealDB.strMeasure12),
            (mealDB.strIngredient13, mealDB.strMeasure13),
            (mealDB.strIngredient14, mealDB.strMeasure14),
            (mealDB.strIngredient15, mealDB.strMeasure15),
            (mealDB.strIngredient16, mealDB.strMeasure16),
            (mealDB.strIngredient17, mealDB.strMeasure17),
            (mealDB.strIngredient18, mealDB.strMeasure18),
            (mealDB.strIngredient19, mealDB.strMeasure19),
            (mealDB.strIngredient20, mealDB.strMeasure20)
        ]
        
        for (ingredient, measure) in ingredientPairs {
            if let ingredient = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines),
               !ingredient.isEmpty,
               ingredient.lowercased() != "null" {
                let measure = measure?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let quantity = measure.isEmpty || measure.lowercased() == "null" ? "To taste" : measure
                ingredients.append(Ingredient(name: ingredient, quantityDescription: quantity))
            }
        }
        
        return ingredients
    }
}

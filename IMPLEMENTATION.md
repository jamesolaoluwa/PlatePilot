# PlatePilot Implementation Guide

## 🏗️ Architecture Overview

PlatePilot follows a clean **Model-View-Controller (MVC)** architecture with clearly separated concerns:

```
PlatePilot/
├── Models/              # Data models (Codable structs)
├── Views/               # Custom UI components and cells
├── ViewControllers/     # View controllers for each screen
├── Networking/          # API client and image loading
├── Persistence/         # Data persistence layer
└── Utilities/           # Helper extensions and utilities
```

---

## 📦 Models

All models are `Codable` for easy persistence and conform to `Equatable` where needed.

### Meal
```swift
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
    
    // Convenience properties
    var caloriesLabelText: String
    var costLabelText: String
    var cookTimeLabelText: String
}
```

### Ingredient
```swift
struct Ingredient: Codable, Equatable {
    var name: String
    var quantityDescription: String
    var isCheckedForGrocery: Bool
}
```

### PlannerDay
```swift
enum DayOfWeek: String, Codable, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

struct PlannerDay: Codable, Equatable {
    var id: String
    var date: Date
    var dayOfWeek: DayOfWeek
    var meals: [Meal]
    
    // Convenience properties
    var totalCalories: Int
    var totalCost: Double
}
```

### GroceryItem
```swift
struct GroceryItem: Codable, Equatable {
    var id: String
    var name: String
    var quantityDescription: String
    var isCompleted: Bool
}
```

### UserSettings
```swift
struct UserSettings: Codable {
    var weeklyBudget: Double
    var calorieGoal: Int
    var notificationsEnabled: Bool
}
```

---

## 🌐 Networking Layer

### APIClient

The `APIClient` singleton handles all network requests to TheMealDB API.

**Key Features:**
- Result-based callbacks for clean error handling
- Automatic JSON decoding to model objects
- Support for search and random meal fetching
- Comprehensive error types

**Usage:**
```swift
// Fetch random meals
APIClient.shared.fetchRandomMeals(count: 20) { result in
    switch result {
    case .success(let meals):
        // Handle meals
    case .failure(let error):
        // Handle error
    }
}

// Search meals
APIClient.shared.searchMeals(query: "chicken") { result in
    // Handle result
}
```

### ImageLoader

Efficient image loading with in-memory caching using `NSCache`.

**Usage:**
```swift
// Direct loading
ImageLoader.shared.loadImage(from: urlString) { image in
    imageView.image = image
}

// UIImageView extension
imageView.loadImage(from: meal.imageURL, placeholder: placeholderImage)
```

---

## 💾 Persistence Layer

### PersistenceManager

Centralized singleton for all data persistence using `UserDefaults` with `JSONEncoder/JSONDecoder`.

**Key Methods:**
```swift
// Favorites
PersistenceManager.shared.saveFavorites(_ meals: [Meal])
PersistenceManager.shared.loadFavorites() -> [Meal]

// Planner
PersistenceManager.shared.savePlannerDays(_ days: [PlannerDay])
PersistenceManager.shared.loadPlannerDays() -> [PlannerDay]

// Grocery
PersistenceManager.shared.saveGroceryItems(_ items: [GroceryItem])
PersistenceManager.shared.loadGroceryItems() -> [GroceryItem]

// Settings
PersistenceManager.shared.saveUserSettings(_ settings: UserSettings)
PersistenceManager.shared.loadUserSettings() -> UserSettings
```

---

## 🎨 Custom Views

### MealTableViewCell

Displays meal information in the home feed with:
- Meal thumbnail image (80x80)
- Meal name (2 lines max)
- Calories, cost, and cook time in horizontal stack

### GroceryItemCell

Checkbox-style cell for grocery list with:
- Checkbox button (circle/checkmark.circle.fill)
- Item name with strikethrough when completed
- Quantity description
- Fade animation on completion

---

## 🎮 View Controllers

### HomeViewController

**Purpose:** Browse meals from API with search/filter capability

**Key Features:**
- Fetches random meals on load
- Custom MealTableViewCell for display
- Activity indicator during loading
- Empty state for no results
- Navigation to MealDetailViewController

**Data Flow:**
```
Load → API Request → Display in TableView → Tap → Push Detail
```

### MealDetailViewController

**Purpose:** Display detailed meal information with actions

**Key Features:**
- Scrollable content with meal image, stats, ingredients, instructions
- Add to Planner button (shows day picker)
- Add to Grocery button (adds all ingredients)
- Favorite toggle with animation
- Persistence integration

**Delegation:**
```swift
protocol MealDetailDelegate: AnyObject {
    func mealDetailDidRequestAddToPlanner(_ meal: Meal)
    func mealDetailDidRequestAddToGrocery(_ meal: Meal)
}
```

### PlannerViewController

**Purpose:** Weekly meal planning with day-based organization

**Key Features:**
- Grouped table view (section per day)
- Section headers show day + total calories + total cost
- Add/remove meals
- Swipe to delete
- Clear all option

**Data Organization:**
```
Monday (500 cal • $12.50)
  ├── Breakfast Item
  ├── Lunch Item
  └── Dinner Item
Tuesday (600 cal • $15.00)
  └── ...
```

### GroceryViewController

**Purpose:** Checklist-style grocery list

**Key Features:**
- Custom checkbox cells
- Tap to toggle completion
- Strikethrough animation
- Clear completed/all options
- Swipe to delete

### ProfileViewController

**Purpose:** User settings and preferences

**Key Features:**
- Weekly budget input
- Daily calorie goal input
- Notifications toggle (placeholder)
- Save button with validation
- Keyboard handling

---

## 🔄 Data Flow

### Adding a Meal to Planner

1. User taps meal in HomeViewController
2. MealDetailViewController displays
3. User taps "Add to Planner"
4. Day picker appears
5. User selects day
6. Meal added to PlannerDay for that day
7. PersistenceManager saves updated data
8. PlannerViewController reloads on next appear

### Adding Ingredients to Grocery

1. User taps "Add to Grocery" in MealDetailViewController
2. All ingredients converted to GroceryItems
3. Duplicates checked and skipped
4. PersistenceManager saves updated list
5. GroceryViewController reloads on next appear

### Favorite Management

1. User taps heart icon
2. Meal.isFavorite toggles
3. Scale animation on button
4. Favorites array updated
5. PersistenceManager saves immediately

---

## 🎯 Key Design Patterns

### Singleton Pattern
- `APIClient.shared`
- `ImageLoader.shared`
- `PersistenceManager.shared`

### Delegation Pattern
- `MealDetailDelegate` for controller communication
- `UITableViewDelegate/DataSource` in extensions

### Result Type
- Network calls return `Result<Data, Error>`
- Clean success/failure handling

### Codable Protocol
- All models conform to Codable
- Easy JSON encoding/decoding

---

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0+
- iOS 15.0+
- Swift 5.0+

### Setup Steps

1. **Open Project**
   ```bash
   cd PlatePilot
   open PlatePilot.xcodeproj
   ```

2. **Configure Storyboard**
   - Follow instructions in `STORYBOARD_CONFIGURATION.md`
   - Set up tab bar icons and titles
   - Configure navigation controllers
   - Set MealDetailViewController storyboard ID

3. **Build and Run**
   - Select a simulator or device
   - Press Cmd+R to build and run
   - App will fetch meals from TheMealDB API

### API Integration

The app uses [TheMealDB API](https://www.themealdb.com/api.php) (free, no API key required):
- Search: `https://www.themealdb.com/api/json/v1/1/search.php?s={query}`
- Random: `https://www.themealdb.com/api/json/v1/1/random.php`

---

## 🧪 Testing

### Manual Testing Checklist

**Home Feed:**
- [ ] Meals load on launch
- [ ] Images load and cache correctly
- [ ] Tap meal navigates to detail
- [ ] Loading indicator shows during fetch
- [ ] Error alerts appear on failure

**Meal Detail:**
- [ ] All meal info displays correctly
- [ ] Favorite toggle works
- [ ] Add to Planner shows day picker
- [ ] Add to Grocery adds ingredients
- [ ] Back navigation works

**Planner:**
- [ ] Meals grouped by day
- [ ] Section headers show totals
- [ ] Swipe to delete works
- [ ] Clear all works
- [ ] Data persists across launches

**Grocery:**
- [ ] Items display with checkbox
- [ ] Tap checkbox toggles completion
- [ ] Strikethrough animation works
- [ ] Clear options work
- [ ] Data persists across launches

**Profile:**
- [ ] Settings load on appear
- [ ] Input fields accept numbers
- [ ] Save button persists data
- [ ] Keyboard dismisses on tap

---

## 🔧 Customization

### Changing Colors

Edit `Utilities/Extensions.swift`:
```swift
extension UIColor {
    static let platePilotPrimary = UIColor.systemBlue
    static let platePilotSecondary = UIColor.systemGreen
    static let platePilotAccent = UIColor.systemOrange
}
```

### Adjusting API

Edit `Networking/APIClient.swift`:
```swift
private let baseURL = "https://www.themealdb.com/api/json/v1/1"
```

### Modifying Calorie Estimates

In `APIClient.swift`, adjust:
```swift
let estimatedCalories = ingredients.count * 50 + Int.random(in: 100...300)
let estimatedCost = Double(ingredients.count) * 1.5 + Double.random(in: 2...8)
```

---

## 📝 Code Style

- **Naming:** camelCase for variables, PascalCase for types
- **Comments:** Use `// MARK:` for section organization
- **Extensions:** Separate protocol conformance into extensions
- **Constants:** Use private enums for grouping
- **Optionals:** Prefer `guard let` over forced unwrapping
- **Layout:** Use programmatic Auto Layout with NSLayoutConstraint

---

## 🐛 Troubleshooting

### Images Not Loading
- Check internet connection
- Verify URL validity
- Check console for network errors

### Data Not Persisting
- Verify PersistenceManager is being called
- Check UserDefaults storage
- Ensure models are Codable

### Storyboard Issues
- Verify all outlets are connected
- Check class names match
- Ensure storyboard IDs are set

### Build Errors
- Clean build folder (Cmd+Shift+K)
- Delete DerivedData
- Check Swift version compatibility

---

## 🎓 Learning Resources

- [Apple's UIKit Documentation](https://developer.apple.com/documentation/uikit)
- [Swift Programming Language Guide](https://docs.swift.org/swift-book/)
- [Auto Layout Guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/)
- [Codable in Swift](https://developer.apple.com/documentation/swift/codable)

---

## 📄 License

This project is created for educational purposes as part of the CodePath iOS course.

---

## 👨🏾‍💻 Developer

**Olaoluwa James-Owolabi**  
CodePath iOS 101 | Capstone Project | 2025

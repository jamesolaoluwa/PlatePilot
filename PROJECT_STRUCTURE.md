# 📁 Project Structure

Complete overview of the PlatePilot project organization.

## Directory Structure

```
PlatePilot/
│
├── AppDelegate.swift              # App lifecycle management
├── SceneDelegate.swift             # Scene lifecycle management
├── Info.plist                      # App configuration
│
├── Models/                         # Data models (Codable)
│   ├── Meal.swift                  # Meal and Ingredient models
│   ├── GroceryItem.swift           # Grocery list item model
│   ├── PlannerDay.swift            # Planner day and DayOfWeek enum
│   └── UserSettings.swift          # User preferences model
│
├── Views/                          # Custom UI components
│   ├── MealTableViewCell.swift     # Home feed meal cell
│   └── GroceryItemCell.swift       # Grocery list item cell
│
├── ViewControllers/                # Screen view controllers
│   ├── HomeViewController.swift           # Browse meals feed
│   ├── MealDetailViewController.swift     # Meal details
│   ├── PlannerViewController.swift        # Weekly planner
│   ├── GroceryViewController.swift        # Grocery checklist
│   └── ProfileViewController.swift        # Settings/profile
│
├── Networking/                     # Network layer
│   ├── APIClient.swift             # TheMealDB API client
│   └── ImageLoader.swift           # Image caching & loading
│
├── Persistence/                    # Data persistence
│   └── PersistenceManager.swift    # UserDefaults manager
│
├── Utilities/                      # Helper utilities
│   └── Extensions.swift            # UIKit & Foundation extensions
│
├── Main.storyboard                 # Main UI storyboard
├── LaunchScreen.storyboard         # Launch screen
│
└── Assets.xcassets/                # Images and colors
    └── AppIcon.appiconset/         # App icon

Documentation/
├── README.md                       # Project overview
├── IMPLEMENTATION.md               # Technical documentation
├── QUICKSTART.md                   # Getting started guide
├── STORYBOARD_CONFIGURATION.md     # Storyboard setup instructions
├── PROJECT_STRUCTURE.md            # This file
└── brainstorm.md                   # Original brainstorming
```

---

## File Descriptions

### Core Files

#### AppDelegate.swift
- Application lifecycle delegate
- Handles app-level events (launch, terminate, etc.)
- Configures app-wide settings

#### SceneDelegate.swift
- Scene lifecycle management (iOS 13+)
- Window setup and scene transitions
- Background/foreground handling

---

## Models Layer

All models are lightweight structs conforming to `Codable` for easy persistence.

### Meal.swift (250 lines)
**Contains:**
- `Ingredient` struct
- `Meal` struct with all meal data
- Convenience computed properties

**Key Properties:**
```swift
- id: String
- name: String
- imageURL: String?
- instructions: String
- ingredients: [Ingredient]
- calories: Int
- estimatedCost: Double
- cookTimeMinutes: Int
- isFavorite: Bool
```

### GroceryItem.swift (30 lines)
**Purpose:** Represents a single grocery list item

**Key Properties:**
```swift
- id: String
- name: String
- quantityDescription: String
- isCompleted: Bool
```

### PlannerDay.swift (70 lines)
**Contains:**
- `DayOfWeek` enum (Monday-Sunday)
- `PlannerDay` struct for organizing meals by day

**Key Features:**
- Computed `totalCalories` and `totalCost`
- Day-based meal organization

### UserSettings.swift (35 lines)
**Purpose:** Store user preferences

**Key Properties:**
```swift
- weeklyBudget: Double
- calorieGoal: Int
- notificationsEnabled: Bool
```

---

## Views Layer

Custom reusable UI components with programmatic Auto Layout.

### MealTableViewCell.swift (150 lines)
**Purpose:** Display meal in home feed

**Components:**
- Meal thumbnail (80x80)
- Meal name label (2 lines)
- Info stack with calories, cost, time

**Methods:**
```swift
- configure(with meal: Meal)
- prepareForReuse()
```

### GroceryItemCell.swift (130 lines)
**Purpose:** Checkbox-style grocery item

**Components:**
- Checkbox button
- Item name with strikethrough support
- Quantity label

**Features:**
- Toggle callback via `onCheckboxTapped`
- Automatic strikethrough on completion
- Fade animation

---

## ViewControllers Layer

### HomeViewController.swift (180 lines)
**Responsibilities:**
- Fetch meals from API
- Display in table view
- Handle navigation to detail
- Show loading/error states

**Key Methods:**
```swift
- loadMeals()
- showError(_ message: String)
- prepare(for segue:)
```

### MealDetailViewController.swift (450 lines)
**Responsibilities:**
- Display full meal details
- Handle favorite toggle
- Add meal to planner
- Add ingredients to grocery

**Protocols:**
```swift
protocol MealDetailDelegate
```

**Key Methods:**
```swift
- configureWithMeal()
- favoriteTapped()
- addToPlannerTapped()
- addToGroceryTapped()
```

### PlannerViewController.swift (200 lines)
**Responsibilities:**
- Display weekly meal plan
- Organize meals by day
- Calculate daily totals
- Delete meals

**Key Methods:**
```swift
- loadPlannerData()
- add(meal:to:)
- clearTapped()
```

### GroceryViewController.swift (180 lines)
**Responsibilities:**
- Display grocery checklist
- Toggle item completion
- Clear items
- Delete items

**Key Methods:**
```swift
- loadGroceryData()
- toggleItemCompletion(at:)
- clearCompletedItems()
- clearAllItems()
```

### ProfileViewController.swift (220 lines)
**Responsibilities:**
- Display user settings
- Save preferences
- Input validation
- Keyboard handling

**Key Methods:**
```swift
- loadSettings()
- saveButtonTapped()
- updateUI()
```

---

## Networking Layer

### APIClient.swift (300 lines)
**Responsibilities:**
- Communicate with TheMealDB API
- Decode JSON responses
- Handle network errors
- Convert API models to app models

**Key Methods:**
```swift
- searchMeals(query:completion:)
- fetchRandomMeals(count:completion:)
- fetchRandomMeal(completion:)
```

**Error Types:**
```swift
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noData
}
```

### ImageLoader.swift (85 lines)
**Responsibilities:**
- Load images from URLs
- Cache images in memory
- Provide UIImageView extension

**Key Methods:**
```swift
- loadImage(from:completion:)
- clearCache()
```

---

## Persistence Layer

### PersistenceManager.swift (130 lines)
**Responsibilities:**
- Save/load data to/from UserDefaults
- Encode/decode with JSON
- Provide type-safe APIs

**Storage Keys:**
```swift
- favorites: [Meal]
- plannerDays: [PlannerDay]
- groceryItems: [GroceryItem]
- userSettings: UserSettings
```

**Pattern:**
```swift
// Save
func saveFavorites(_ favorites: [Meal])

// Load
func loadFavorites() -> [Meal]
```

---

## Utilities Layer

### Extensions.swift (150 lines)
**Provides:**
- UIColor custom colors
- UIView animation helpers
- Date formatting
- String utilities
- Array extensions for Meal calculations

**Key Extensions:**
```swift
extension UIColor {
    static let platePilotPrimary
    static let platePilotSecondary
    static let platePilotAccent
}

extension UIView {
    func addShadow()
    func animateScale()
    func fadeIn/fadeOut()
}

extension Date {
    func dayOfWeek() -> DayOfWeek?
    func formatted() -> String
}

extension Array where Element == Meal {
    var totalCalories: Int
    var totalCost: Double
}
```

---

## Storyboards

### Main.storyboard
**Contains:**
- Tab Bar Controller (initial)
- 4 Navigation Controllers
- 4 root view controllers (Home, Planner, Grocery, Profile)
- MealDetailViewController (referenced by storyboard ID)

**Configuration Required:**
- Tab bar icons and titles
- Navigation bar settings
- Storyboard IDs
- See STORYBOARD_CONFIGURATION.md for details

### LaunchScreen.storyboard
**Contains:**
- Simple centered label: "PlatePilot"
- White background
- System font styling

---

## Dependencies

### External APIs
- **TheMealDB**: Free meal database API
  - Base URL: `https://www.themealdb.com/api/json/v1/1`
  - No API key required
  - Rate limit: Reasonable

### System Frameworks
```swift
import UIKit          // All UI components
import Foundation     // Data models and utilities
```

### No Third-Party Libraries
- Pure UIKit implementation
- Native URLSession for networking
- Native NSCache for image caching
- UserDefaults for persistence

---

## Code Metrics

| Component | Lines of Code | Files |
|-----------|--------------|-------|
| Models | ~400 | 4 |
| Views | ~280 | 2 |
| ViewControllers | ~1230 | 5 |
| Networking | ~385 | 2 |
| Persistence | ~130 | 1 |
| Utilities | ~150 | 1 |
| **Total** | **~2575** | **15** |

---

## Design Patterns Used

1. **Singleton**: APIClient, ImageLoader, PersistenceManager
2. **Delegation**: MealDetailDelegate, TableView delegates
3. **MVC**: Clear separation of concerns
4. **Factory**: Cell creation and configuration
5. **Observer**: NotificationCenter (keyboard events)
6. **Result**: Network response handling

---

## Best Practices Implemented

✅ Clean separation of concerns (MVC)  
✅ Codable for model serialization  
✅ Programmatic Auto Layout  
✅ Protocol-oriented design  
✅ Type-safe APIs  
✅ Error handling with Result  
✅ Memory-efficient image caching  
✅ Reusable custom cells  
✅ Extensions for protocol conformance  
✅ Comprehensive inline documentation  

---

## Testing Strategy

### Unit Testing Targets
- Model encoding/decoding
- APIClient response parsing
- PersistenceManager save/load
- Extension helper methods

### UI Testing Targets
- Navigation flow
- Cell interactions
- Form inputs
- Table view operations

### Integration Testing
- End-to-end meal flow
- Data persistence
- API integration

---

## Future Extensibility

### Easy to Add:
- New meal sources (different APIs)
- Additional screens (favorites, search)
- More persistence options (Core Data, CloudKit)
- Analytics and logging
- Push notifications
- Dark mode customization

### Modular Design:
Each layer is independent and can be:
- Tested separately
- Modified without affecting others
- Extended with new features
- Replaced with alternatives

---

## Version Control

### Recommended .gitignore
Already configured to exclude:
- `xcuserdata/`
- `build/`
- `DerivedData/`
- `.DS_Store`

### Commit Strategy
- Small, focused commits
- Descriptive commit messages
- Separate commits per feature
- Document breaking changes

---

## Performance Considerations

### Optimizations:
- Image caching with NSCache (50MB limit)
- Lazy table cell loading
- Async image downloads
- JSON encoding/decoding on background queue (future)

### Memory Management:
- Weak references in closures
- Proper deallocation
- Cache limits
- Image downsampling (future enhancement)

---

This structure provides a scalable, maintainable foundation for PlatePilot! 🚀

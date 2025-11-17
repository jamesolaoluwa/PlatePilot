# Storyboard Configuration Guide

This document provides detailed instructions for configuring the storyboards in Xcode Interface Builder.

## Main.storyboard Configuration

### Tab Bar Controller Setup

1. **Initial View Controller**: Set `UITabBarController` as the initial view controller (check "Is Initial View Controller")

2. **Tab Bar Items**: Configure each tab with:
   - **Home Tab**:
     - Icon: SF Symbol "house"
     - Title: "Meals"
   - **Planner Tab**:
     - Icon: SF Symbol "calendar"
     - Title: "Planner"
   - **Grocery Tab**:
     - Icon: SF Symbol "cart"
     - Title: "Grocery"
   - **Profile Tab**:
     - Icon: SF Symbol "person.crop.circle"
     - Title: "Profile"

### HomeViewController Setup

1. **Navigation Controller**: Already embedded in Navigation Controller
2. **TableView**:
   - Add `UITableView` to the view
   - Pin to all edges (0, 0, 0, 0) to safe area
   - Connect outlet: `@IBOutlet weak var tableView: UITableView!`
   - Set `dataSource` and `delegate` to the view controller
3. **Navigation Bar**:
   - Set title to "Meals"
   - Enable "Prefers Large Titles"

### PlannerViewController Setup

1. **Navigation Controller**: Already embedded in Navigation Controller
2. **UI Elements**: All UI is created programmatically (no outlets needed)
3. **Navigation Bar**:
   - Set title to "Planner"
   - Enable "Prefers Large Titles"

### GroceryViewController Setup

1. **Navigation Controller**: Already embedded in Navigation Controller
2. **UI Elements**: All UI is created programmatically (no outlets needed)
3. **Navigation Bar**:
   - Set title to "Grocery List"
   - Enable "Prefers Large Titles"

### ProfileViewController Setup

1. **Navigation Controller**: Already embedded in Navigation Controller
2. **UI Elements**: All UI is created programmatically (no outlets needed)
3. **Navigation Bar**:
   - Set title to "Profile"
   - Enable "Prefers Large Titles"

### MealDetailViewController Setup

1. **Create New Scene**:
   - Add a new `UIViewController` to the storyboard
   - Set the class to `MealDetailViewController`
   - Set Storyboard ID to `MealDetailViewController`
2. **UI Elements**: All UI is created programmatically (no outlets needed)
3. **Navigation**: 
   - Will be pushed programmatically from HomeViewController
   - No segue needed in storyboard

## LaunchScreen.storyboard Configuration

Configure the launch screen with a clean, professional design:

1. **Background**: Set to white (`systemBackground`)

2. **App Name Label**:
   - Text: "PlatePilot"
   - Font: System Bold, 34pt
   - Color: System Blue
   - Alignment: Center
   - Constraints: Center horizontally and vertically (offset -50 from center Y)

3. **Tagline Label**:
   - Text: "Eat smarter. Save more. Live healthier."
   - Font: System Regular, 17pt
   - Color: System Gray
   - Alignment: Center
   - Number of Lines: 0
   - Constraints: Center horizontally, 16pt below app name label

4. **Icon (Optional)**:
   - Add a `UIImageView` with an SF Symbol
   - Symbol: "fork.knife.circle.fill" or "leaf.circle.fill"
   - Tint Color: System Green
   - Size: 80x80
   - Constraints: Center horizontally, 40pt above app name label

## Auto Layout Best Practices

### Constraints Pattern
- Always pin to safe area layout guide
- Use standard spacing (8, 12, 16, 20, 24)
- Set proper content hugging and compression resistance priorities
- Use stack views where appropriate for cleaner layouts

### Dynamic Type Support
- Use system fonts with weight variants
- Set `adjustsFontForContentSizeCategory = true` where needed
- Test with different text sizes (Settings > Accessibility > Display & Text Size)

### Multi-Device Support
- Use proportional constraints where appropriate
- Test on different screen sizes (SE, regular, Plus/Max)
- Ensure scroll views can scroll when keyboard appears

## Custom Cell Registration

### In Code (Already Implemented)
- `MealTableViewCell` - Registered in HomeViewController
- `GroceryItemCell` - Registered in GroceryViewController
- Standard cells registered where needed

### Reuse Identifiers
- `MealTableViewCell.identifier` = "MealTableViewCell"
- `GroceryItemCell.identifier` = "GroceryItemCell"
- Use static identifiers defined in cell classes

## Navigation Flow

```
TabBarController
├── NavigationController (Home)
│   └── HomeViewController
│       └── (Push) MealDetailViewController
├── NavigationController (Planner)
│   └── PlannerViewController
│       └── (Push) MealDetailViewController
├── NavigationController (Grocery)
│   └── GroceryViewController
└── NavigationController (Profile)
    └── ProfileViewController
```

## Color Scheme

- Primary: System Blue
- Secondary: System Green
- Accent: System Orange
- Background: System Background
- Secondary Background: Secondary System Grouped Background
- Text: Label (adapts to light/dark mode)
- Secondary Text: Secondary Label

## SF Symbols Used

- `house` - Home tab
- `calendar` - Planner tab
- `cart` - Grocery tab
- `person.crop.circle` - Profile tab
- `fork.knife` - Meal placeholder
- `heart` / `heart.fill` - Favorite toggle
- `checkmark.circle` / `checkmark.circle.fill` - Grocery checkbox
- `line.3.horizontal.decrease.circle` - Filter button

## Testing Checklist

- [ ] All tab bar items show correct icons and titles
- [ ] Navigation bars show correct titles
- [ ] Large titles are enabled where specified
- [ ] All outlets are connected (TableViews in Home/Grocery if using IB)
- [ ] Storyboard ID is set for MealDetailViewController
- [ ] Launch screen displays correctly
- [ ] App launches without storyboard errors
- [ ] Navigation between screens works correctly
- [ ] All custom cells render properly

## Notes

- Most UI is created programmatically for better control and testability
- Storyboards are used primarily for navigation structure and initial setup
- Custom cells are registered in code, not in Interface Builder
- This approach provides flexibility while maintaining the benefits of visual layout

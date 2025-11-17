# 🚀 Quick Start Guide

Get PlatePilot up and running in 5 minutes!

## Step 1: Clone and Open

```bash
git clone <repository-url>
cd PlatePilot
open PlatePilot.xcodeproj
```

## Step 2: Configure Storyboard (Required)

Open `Main.storyboard` and configure the Tab Bar:

### Tab Bar Items (Select each tab and set in Attributes Inspector):

1. **Home Tab** 
   - Icon: `house` (SF Symbol)
   - Title: "Meals"

2. **Planner Tab**
   - Icon: `calendar` (SF Symbol)
   - Title: "Planner"

3. **Grocery Tab**
   - Icon: `cart` (SF Symbol)
   - Title: "Grocery"

4. **Profile Tab**
   - Icon: `person.crop.circle` (SF Symbol)
   - Title: "Profile"

### Add MealDetailViewController:

1. Drag a new `UIViewController` onto storyboard
2. Set Class: `MealDetailViewController` (Identity Inspector)
3. Set Storyboard ID: `MealDetailViewController` (Identity Inspector)

### Enable Large Titles:

For each Navigation Controller:
1. Select the Navigation Bar
2. In Attributes Inspector, check "Prefers Large Titles"

## Step 3: Build and Run

1. Select a simulator (iPhone 14 or later recommended)
2. Press **⌘R** or click the Run button
3. Wait for build to complete

## Step 4: Test the App

### First Launch
- App will fetch 20 random meals from TheMealDB
- May take a few seconds to load images

### Try These Actions:

**Home Screen:**
- Scroll through meal list
- Tap any meal to view details

**Meal Detail:**
- Tap heart icon to favorite
- Tap "Add to Planner" and select a day
- Tap "Add to Grocery" to add ingredients

**Planner:**
- View meals organized by day
- See total calories and cost per day
- Swipe left on a meal to delete

**Grocery:**
- Tap checkbox to mark items complete
- See strikethrough animation
- Swipe left to delete items

**Profile:**
- Set weekly budget (e.g., 50.00)
- Set calorie goal (e.g., 2000)
- Tap "Save Settings"

## Step 5: Verify Data Persistence

1. Add some meals to planner
2. Add ingredients to grocery
3. Favorite some meals
4. Close the app completely
5. Reopen the app
6. ✅ All data should be preserved!

---

## 🎯 Quick Feature Overview

| Feature | Screen | Action |
|---------|--------|--------|
| Browse Meals | Home | Tap to view details |
| Favorite Meal | Detail | Tap heart icon |
| Add to Planner | Detail | Choose day from picker |
| Add to Grocery | Detail | Adds all ingredients |
| Complete Grocery | Grocery | Tap checkbox |
| Set Budget | Profile | Enter amount & save |
| Set Calories | Profile | Enter goal & save |

---

## 🐛 Common Issues

### "No meals found"
- Check internet connection
- The API might be temporarily down
- Pull to refresh (if implemented) or restart app

### Images not loading
- Images load asynchronously
- Wait a few seconds
- Check internet connection

### App crashes on launch
- Clean build folder: **⌘⇧K**
- Delete DerivedData
- Rebuild project

### Storyboard warnings
- Make sure all outlets are connected
- Verify class names are correct
- Check storyboard IDs match code

---

## 📱 Recommended Test Devices

- iPhone SE (3rd generation) - Small screen
- iPhone 14/15 - Standard screen
- iPhone 14/15 Pro Max - Large screen

---

## 🔗 Helpful Links

- **Full Documentation:** See `IMPLEMENTATION.md`
- **Storyboard Setup:** See `STORYBOARD_CONFIGURATION.md`
- **API Reference:** [TheMealDB API](https://www.themealdb.com/api.php)

---

## ✅ Quick Validation Checklist

After setup, verify:

- [ ] App launches without errors
- [ ] Tab bar shows 4 tabs with correct icons
- [ ] Home screen loads meals
- [ ] Can navigate to meal detail
- [ ] Can add meals to planner
- [ ] Can add items to grocery
- [ ] Can toggle favorites
- [ ] Data persists after app restart
- [ ] All navigation works correctly

---

## 🆘 Need Help?

1. Check the full documentation in `IMPLEMENTATION.md`
2. Review storyboard setup in `STORYBOARD_CONFIGURATION.md`
3. Look at code comments for inline documentation
4. Check console logs for error messages

---

**You're all set! Enjoy using PlatePilot! 🎉**

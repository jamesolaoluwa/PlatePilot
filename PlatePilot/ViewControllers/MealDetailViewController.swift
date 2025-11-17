//
//  MealDetailViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

// MARK: - Protocol

protocol MealDetailDelegate: AnyObject {
    func mealDetailDidRequestAddToPlanner(_ meal: Meal)
    func mealDetailDidRequestAddToGrocery(_ meal: Meal)
}

class MealDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var meal: Meal!
    weak var delegate: MealDetailDelegate?
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ingredientsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let instructionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addToPlannerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Planner", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addToGroceryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Grocery", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configureWithMeal()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(buttonContainerView)
        scrollView.addSubview(contentStackView)
        
        // Configure favorite button in navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        // Add image to content
        contentStackView.addArrangedSubview(mealImageView)
        
        // Create a container for name and stats
        let infoContainer = UIView()
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        infoContainer.addSubview(nameLabel)
        infoContainer.addSubview(statsStackView)
        
        contentStackView.addArrangedSubview(infoContainer)
        
        // Add sections
        contentStackView.addArrangedSubview(ingredientsHeaderLabel)
        contentStackView.addArrangedSubview(ingredientsStackView)
        contentStackView.addArrangedSubview(instructionsHeaderLabel)
        contentStackView.addArrangedSubview(instructionsLabel)
        
        // Add spacing at the bottom
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        contentStackView.addArrangedSubview(spacer)
        
        // Setup buttons
        buttonContainerView.addSubview(addToPlannerButton)
        buttonContainerView.addSubview(addToGroceryButton)
        
        addToPlannerButton.addTarget(self, action: #selector(addToPlannerTapped), for: .touchUpInside)
        addToGroceryButton.addTarget(self, action: #selector(addToGroceryTapped), for: .touchUpInside)
        
        // Layout constraints
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            
            // Content Stack View
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Meal Image
            mealImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Name and Stats
            nameLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            
            statsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            statsStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            statsStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -8),
            
            // Section headers padding
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16),
            instructionsHeaderLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16),
            
            // Button Container
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            // Buttons
            addToPlannerButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 12),
            addToPlannerButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 16),
            addToPlannerButton.trailingAnchor.constraint(equalTo: buttonContainerView.centerXAnchor, constant: -8),
            addToPlannerButton.heightAnchor.constraint(equalToConstant: 50),
            
            addToGroceryButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 12),
            addToGroceryButton.leadingAnchor.constraint(equalTo: buttonContainerView.centerXAnchor, constant: 8),
            addToGroceryButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -16),
            addToGroceryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add padding to ingredients and instructions
        contentStackView.setCustomSpacing(8, after: ingredientsHeaderLabel)
        contentStackView.setCustomSpacing(8, after: instructionsHeaderLabel)
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func configureWithMeal() {
        guard meal != nil else { return }
        
        // Load image
        mealImageView.loadImage(from: meal.imageURL, placeholder: UIImage(systemName: "fork.knife"))
        
        // Set name
        nameLabel.text = meal.name
        
        // Create stat cards
        statsStackView.addArrangedSubview(createStatView(icon: "🔥", label: meal.caloriesLabelText))
        statsStackView.addArrangedSubview(createStatView(icon: "💵", label: meal.costLabelText))
        statsStackView.addArrangedSubview(createStatView(icon: "⏱", label: meal.cookTimeLabelText))
        
        // Add ingredients
        for ingredient in meal.ingredients {
            let ingredientLabel = UILabel()
            ingredientLabel.font = .systemFont(ofSize: 15)
            ingredientLabel.numberOfLines = 0
            ingredientLabel.text = "• \(ingredient.name) - \(ingredient.quantityDescription)"
            ingredientsStackView.addArrangedSubview(ingredientLabel)
        }
        
        // Set instructions
        instructionsLabel.text = meal.instructions
        
        // Update favorite button
        updateFavoriteButton()
    }
    
    private func createStatView(icon: String, label: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 24)
        
        let textLabel = UILabel()
        textLabel.text = label
        textLabel.font = .systemFont(ofSize: 14, weight: .medium)
        textLabel.textAlignment = .center
        
        stackView.addArrangedSubview(iconLabel)
        stackView.addArrangedSubview(textLabel)
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 70),
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -4)
        ])
        
        return container
    }
    
    // MARK: - Actions
    
    @objc private func favoriteTapped() {
        meal.isFavorite.toggle()
        updateFavoriteButton()
        
        // Save to favorites
        var favorites = PersistenceManager.shared.loadFavorites()
        if meal.isFavorite {
            // Add to favorites if not already there
            if !favorites.contains(where: { $0.id == meal.id }) {
                favorites.append(meal)
                
                // Animate button
                UIView.animate(withDuration: 0.2, animations: {
                    self.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }) { _ in
                    UIView.animate(withDuration: 0.2) {
                        self.favoriteButton.transform = .identity
                    }
                }
            }
        } else {
            // Remove from favorites
            favorites.removeAll(where: { $0.id == meal.id })
        }
        PersistenceManager.shared.saveFavorites(favorites)
    }
    
    private func updateFavoriteButton() {
        let imageName = meal.isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func addToPlannerTapped() {
        // Show day selector
        let alert = UIAlertController(title: "Add to Planner", message: "Select a day to add this meal", preferredStyle: .actionSheet)
        
        for day in DayOfWeek.allCases {
            alert.addAction(UIAlertAction(title: day.rawValue, style: .default) { [weak self] _ in
                self?.addMealToPlanner(day: day)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = addToPlannerButton
            popover.sourceRect = addToPlannerButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func addMealToPlanner(day: DayOfWeek) {
        var plannerDays = PersistenceManager.shared.loadPlannerDays()
        
        // Find or create the planner day
        if let index = plannerDays.firstIndex(where: { $0.dayOfWeek == day }) {
            plannerDays[index].meals.append(meal)
        } else {
            let newDay = PlannerDay(date: Date(), dayOfWeek: day, meals: [meal])
            plannerDays.append(newDay)
        }
        
        PersistenceManager.shared.savePlannerDays(plannerDays)
        delegate?.mealDetailDidRequestAddToPlanner(meal)
        
        showSuccessAlert(message: "Meal added to \(day.rawValue)")
    }
    
    @objc private func addToGroceryTapped() {
        var groceryItems = PersistenceManager.shared.loadGroceryItems()
        
        for ingredient in meal.ingredients {
            // Check if ingredient already exists
            if !groceryItems.contains(where: { $0.name.lowercased() == ingredient.name.lowercased() }) {
                let item = GroceryItem(name: ingredient.name, quantityDescription: ingredient.quantityDescription)
                groceryItems.append(item)
            }
        }
        
        PersistenceManager.shared.saveGroceryItems(groceryItems)
        delegate?.mealDetailDidRequestAddToGrocery(meal)
        
        showSuccessAlert(message: "Ingredients added to grocery list")
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

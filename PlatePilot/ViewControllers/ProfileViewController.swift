//
//  ProfileViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var userSettings: UserSettings = UserSettings()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Budget"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let budgetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "$50.00"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Calorie Goal"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let calorieTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "2000"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Settings", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        loadSettings()
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Budget section
        let budgetContainer = createSettingContainer()
        budgetContainer.addSubview(budgetLabel)
        budgetContainer.addSubview(budgetTextField)
        
        NSLayoutConstraint.activate([
            budgetLabel.topAnchor.constraint(equalTo: budgetContainer.topAnchor, constant: 12),
            budgetLabel.leadingAnchor.constraint(equalTo: budgetContainer.leadingAnchor, constant: 16),
            budgetLabel.trailingAnchor.constraint(equalTo: budgetContainer.trailingAnchor, constant: -16),
            
            budgetTextField.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 8),
            budgetTextField.leadingAnchor.constraint(equalTo: budgetContainer.leadingAnchor, constant: 16),
            budgetTextField.trailingAnchor.constraint(equalTo: budgetContainer.trailingAnchor, constant: -16),
            budgetTextField.bottomAnchor.constraint(equalTo: budgetContainer.bottomAnchor, constant: -12),
            budgetTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Calorie section
        let calorieContainer = createSettingContainer()
        calorieContainer.addSubview(calorieLabel)
        calorieContainer.addSubview(calorieTextField)
        
        NSLayoutConstraint.activate([
            calorieLabel.topAnchor.constraint(equalTo: calorieContainer.topAnchor, constant: 12),
            calorieLabel.leadingAnchor.constraint(equalTo: calorieContainer.leadingAnchor, constant: 16),
            calorieLabel.trailingAnchor.constraint(equalTo: calorieContainer.trailingAnchor, constant: -16),
            
            calorieTextField.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 8),
            calorieTextField.leadingAnchor.constraint(equalTo: calorieContainer.leadingAnchor, constant: 16),
            calorieTextField.trailingAnchor.constraint(equalTo: calorieContainer.trailingAnchor, constant: -16),
            calorieTextField.bottomAnchor.constraint(equalTo: calorieContainer.bottomAnchor, constant: -12),
            calorieTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Notifications section
        let notificationsContainer = createSettingContainer()
        notificationsContainer.addSubview(notificationsLabel)
        notificationsContainer.addSubview(notificationsSwitch)
        
        NSLayoutConstraint.activate([
            notificationsLabel.leadingAnchor.constraint(equalTo: notificationsContainer.leadingAnchor, constant: 16),
            notificationsLabel.centerYAnchor.constraint(equalTo: notificationsContainer.centerYAnchor),
            
            notificationsSwitch.trailingAnchor.constraint(equalTo: notificationsContainer.trailingAnchor, constant: -16),
            notificationsSwitch.centerYAnchor.constraint(equalTo: notificationsContainer.centerYAnchor),
            
            notificationsContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add to stack
        contentStackView.addArrangedSubview(headerLabel)
        contentStackView.addArrangedSubview(budgetContainer)
        contentStackView.addArrangedSubview(calorieContainer)
        contentStackView.addArrangedSubview(notificationsContainer)
        contentStackView.addArrangedSubview(saveButton)
        
        // Save button action
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Layout
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createSettingContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    // MARK: - Data Loading
    
    private func loadSettings() {
        userSettings = PersistenceManager.shared.loadUserSettings()
        updateUI()
    }
    
    private func updateUI() {
        budgetTextField.text = String(format: "%.2f", userSettings.weeklyBudget)
        calorieTextField.text = "\(userSettings.calorieGoal)"
        notificationsSwitch.isOn = userSettings.notificationsEnabled
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        // Parse budget
        if let budgetText = budgetTextField.text,
           let budget = Double(budgetText) {
            userSettings.weeklyBudget = budget
        }
        
        // Parse calorie goal
        if let calorieText = calorieTextField.text,
           let calories = Int(calorieText) {
            userSettings.calorieGoal = calories
        }
        
        // Get notifications setting
        userSettings.notificationsEnabled = notificationsSwitch.isOn
        
        // Save to persistence
        PersistenceManager.shared.saveUserSettings(userSettings)
        
        // Show success feedback
        let alert = UIAlertController(title: "Success", message: "Settings saved successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
        dismissKeyboard()
    }
}

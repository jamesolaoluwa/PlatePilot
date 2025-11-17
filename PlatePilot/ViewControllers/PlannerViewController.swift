//
//  PlannerViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class PlannerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var plannerDays: [PlannerDay] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No meals planned yet.\nAdd meals from the home feed!"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlannerData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Planner"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add clear button
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MealCell")
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: - Data Loading
    
    private func loadPlannerData() {
        plannerDays = PersistenceManager.shared.loadPlannerDays()
        
        // Sort by day of week
        plannerDays.sort { day1, day2 in
            let order = DayOfWeek.allCases
            guard let index1 = order.firstIndex(of: day1.dayOfWeek),
                  let index2 = order.firstIndex(of: day2.dayOfWeek) else {
                return false
            }
            return index1 < index2
        }
        
        tableView.reloadData()
        
        // Show/hide empty state
        let isEmpty = plannerDays.allSatisfy { $0.meals.isEmpty }
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func clearTapped() {
        let alert = UIAlertController(title: "Clear Planner", message: "Are you sure you want to remove all planned meals?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            PersistenceManager.shared.savePlannerDays([])
            self?.loadPlannerData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func add(meal: Meal, to dayOfWeek: DayOfWeek) {
        var days = PersistenceManager.shared.loadPlannerDays()
        
        if let index = days.firstIndex(where: { $0.dayOfWeek == dayOfWeek }) {
            days[index].meals.append(meal)
        } else {
            let newDay = PlannerDay(date: Date(), dayOfWeek: dayOfWeek, meals: [meal])
            days.append(newDay)
        }
        
        PersistenceManager.shared.savePlannerDays(days)
        loadPlannerData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PlannerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return plannerDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plannerDays[section].meals.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = plannerDays[section]
        let totalCal = day.totalCalories
        let totalCost = String(format: "$%.2f", day.totalCost)
        return "\(day.dayLabel) • \(totalCal) cal • \(totalCost)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        let meal = plannerDays[indexPath.section].meals[indexPath.row]
        
        cell.textLabel?.text = meal.name
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "\(meal.caloriesLabelText) • \(meal.costLabelText)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let meal = plannerDays[indexPath.section].meals[indexPath.row]
        
        // Navigate to detail view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "MealDetailViewController") as? MealDetailViewController {
            detailVC.meal = meal
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove meal from planner
            var days = plannerDays
            days[indexPath.section].meals.remove(at: indexPath.row)
            
            // If section is now empty, remove it
            if days[indexPath.section].meals.isEmpty {
                days.remove(at: indexPath.section)
            }
            
            PersistenceManager.shared.savePlannerDays(days)
            loadPlannerData()
        }
    }
}

// MARK: - MealDetailDelegate

extension PlannerViewController: MealDetailDelegate {
    func mealDetailDidRequestAddToPlanner(_ meal: Meal) {
        loadPlannerData()
    }
    
    func mealDetailDidRequestAddToGrocery(_ meal: Meal) {
        // Not handled here
    }
}

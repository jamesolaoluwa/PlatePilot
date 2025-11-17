//
//  GroceryViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class GroceryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var groceryItems: [GroceryItem] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Your grocery list is empty.\nAdd ingredients from meal details!"
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
        loadGroceryData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Grocery List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add clear button
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearTapped))
        navigationItem.rightBarButtonItem = clearButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroceryItemCell.self, forCellReuseIdentifier: GroceryItemCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 58, bottom: 0, right: 16)
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
    
    private func loadGroceryData() {
        groceryItems = PersistenceManager.shared.loadGroceryItems()
        tableView.reloadData()
        
        // Show/hide empty state
        emptyStateLabel.isHidden = !groceryItems.isEmpty
        tableView.isHidden = groceryItems.isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func clearTapped() {
        let alert = UIAlertController(title: "Clear List", message: "Choose an option:", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Clear Completed Items", style: .default) { [weak self] _ in
            self?.clearCompletedItems()
        })
        
        alert.addAction(UIAlertAction(title: "Clear All Items", style: .destructive) { [weak self] _ in
            self?.clearAllItems()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    private func clearCompletedItems() {
        groceryItems.removeAll(where: { $0.isCompleted })
        PersistenceManager.shared.saveGroceryItems(groceryItems)
        loadGroceryData()
    }
    
    private func clearAllItems() {
        let alert = UIAlertController(title: "Clear All Items", message: "Are you sure you want to clear your entire grocery list?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            PersistenceManager.shared.saveGroceryItems([])
            self?.loadGroceryData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func toggleItemCompletion(at index: Int) {
        groceryItems[index].isCompleted.toggle()
        PersistenceManager.shared.saveGroceryItems(groceryItems)
        
        // Animate the change
        UIView.animate(withDuration: 0.3) {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension GroceryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroceryItemCell.identifier, for: indexPath) as? GroceryItemCell else {
            return UITableViewCell()
        }
        
        let item = groceryItems[indexPath.row]
        cell.configure(with: item)
        cell.onCheckboxTapped = { [weak self] in
            self?.toggleItemCompletion(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groceryItems.remove(at: indexPath.row)
            PersistenceManager.shared.saveGroceryItems(groceryItems)
            loadGroceryData()
        }
    }
}

// MARK: - MealDetailDelegate

extension GroceryViewController: MealDetailDelegate {
    func mealDetailDidRequestAddToPlanner(_ meal: Meal) {
        // Not handled here
    }
    
    func mealDetailDidRequestAddToGrocery(_ meal: Meal) {
        loadGroceryData()
    }
}

//
//  GroceryItemCell.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class GroceryItemCell: UITableViewCell {
    
    static let identifier = "GroceryItemCell"
    
    // MARK: - UI Components
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onCheckboxTapped: (() -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(checkboxButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(quantityLabel)
        
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Checkbox Button
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 30),
            checkboxButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            // Quantity Label
            quantityLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            quantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func checkboxTapped() {
        onCheckboxTapped?()
    }
    
    // MARK: - Configuration
    
    func configure(with item: GroceryItem) {
        nameLabel.text = item.name
        quantityLabel.text = item.quantityDescription
        
        updateCheckboxAppearance(isCompleted: item.isCompleted)
    }
    
    private func updateCheckboxAppearance(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        // Apply strikethrough and fade if completed
        let attributes: [NSAttributedString.Key: Any] = isCompleted ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        nameLabel.attributedText = NSAttributedString(string: nameLabel.text ?? "", attributes: attributes)
        nameLabel.alpha = isCompleted ? 0.5 : 1.0
        quantityLabel.alpha = isCompleted ? 0.5 : 1.0
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        quantityLabel.text = nil
        nameLabel.attributedText = nil
        nameLabel.alpha = 1.0
        quantityLabel.alpha = 1.0
        onCheckboxTapped = nil
    }
}

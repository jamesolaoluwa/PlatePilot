//
//  MealTableViewCell.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    static let identifier = "MealTableViewCell"
    
    // MARK: - UI Components
    
    private let mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
        contentView.addSubview(mealImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(caloriesLabel)
        infoStackView.addArrangedSubview(costLabel)
        infoStackView.addArrangedSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            // Image View
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mealImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mealImageView.widthAnchor.constraint(equalToConstant: 80),
            mealImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            // Info Stack View
            infoStackView.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with meal: Meal) {
        titleLabel.text = meal.name
        caloriesLabel.text = "🔥 \(meal.caloriesLabelText)"
        costLabel.text = "💵 \(meal.costLabelText)"
        timeLabel.text = "⏱ \(meal.cookTimeLabelText)"
        
        mealImageView.loadImage(from: meal.imageURL, placeholder: UIImage(systemName: "fork.knife"))
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealImageView.image = nil
        titleLabel.text = nil
        caloriesLabel.text = nil
        costLabel.text = nil
        timeLabel.text = nil
    }
}

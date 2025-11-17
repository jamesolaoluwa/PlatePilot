//
//  Extensions.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

// MARK: - UIColor Extension

extension UIColor {
    static let platePilotPrimary = UIColor.systemBlue
    static let platePilotSecondary = UIColor.systemGreen
    static let platePilotAccent = UIColor.systemOrange
}

// MARK: - UIView Extension

extension UIView {
    
    /// Add a subtle shadow to a view
    func addShadow(opacity: Float = 0.1, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    
    /// Add a border to a view
    func addBorder(color: UIColor = .systemGray4, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Animate a scale effect
    func animateScale(to scale: CGFloat, duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: duration) {
                self.transform = .identity
            }
            completion?()
        }
    }
    
    /// Fade in animation
    func fadeIn(duration: TimeInterval = 0.3) {
        alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    /// Fade out animation
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            completion?()
        }
    }
}

// MARK: - Date Extension

extension Date {
    
    /// Get day of week from date
    func dayOfWeek() -> DayOfWeek? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        
        // weekday: 1 = Sunday, 2 = Monday, ..., 7 = Saturday
        switch weekday {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        case 1: return .sunday
        default: return nil
        }
    }
    
    /// Format date as string
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}

// MARK: - String Extension

extension String {
    
    /// Truncate string to a certain length
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }
    
    /// Check if string is a valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

// MARK: - Array Extension

extension Array where Element == Meal {
    
    /// Calculate total calories
    var totalCalories: Int {
        return reduce(0) { $0 + $1.calories }
    }
    
    /// Calculate total cost
    var totalCost: Double {
        return reduce(0) { $0 + $1.estimatedCost }
    }
}

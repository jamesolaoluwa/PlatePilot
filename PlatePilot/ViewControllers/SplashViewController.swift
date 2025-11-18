//
//  SplashViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - UI Components

    private let logoImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "fork.knife.circle.fill"))
        image.tintColor = .systemGreen
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PlatePilot"
        label.textColor = .white   // UPDATED from systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Eat smarter. Save more. Live healthier."
        label.textColor = .white   // UPDATED from systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gradientLayer = CAGradientLayer()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEntrance()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(taglineLabel)

        taglineLabel.transform = CGAffineTransform(translationX: 0, y: 40) // Slide from bottom

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),

            taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            taglineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            taglineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Gradient Background

    private func setupGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.systemGreen.withAlphaComponent(0.15).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        animateGradient()
    }

    private func animateGradient() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [
            UIColor.systemGreen.withAlphaComponent(0.15).cgColor,
            UIColor.systemBackground.cgColor
        ]
        animation.duration = 3
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "gradientShift")
    }

    // MARK: - Entrance Animation

    private func animateEntrance() {
        // Start smaller & below position
        titleLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            .concatenating(CGAffineTransform(translationX: 0, y: 25))

        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseInOut,
                       animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }, completion: { _ in
            self.triggerHaptics()
            self.animateTagline()
        })
    }


    private func animateTagline() {
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .curveEaseOut, animations: {
            self.taglineLabel.alpha = 1
            self.taglineLabel.transform = .identity
        }, completion: { _ in
            self.fadeAndNavigate()
        })
    }

    private func triggerHaptics() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }


    // MARK: - Transition

    private func fadeAndNavigate() {
        UIView.animate(withDuration: 0.6, delay: 1.2, options: .curveEaseOut, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabController = storyboard.instantiateViewController(withIdentifier: "MainTabController")

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = tabController
                window.makeKeyAndVisible()
            }
        })
    }
    
    
//    private func fadeAndNavigate() {
//        UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveLinear, animations: {
//            self.view.alpha = 0
//        }, completion: { _ in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let tabController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
//
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let sceneDelegate = windowScene.delegate as? SceneDelegate,
//               let window = sceneDelegate.window {
//
//                window.rootViewController = tabController
//                window.makeKeyAndVisible()
//            }
//        })
//    }


}

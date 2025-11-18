//
//  SplashViewController.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - UI Elements

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
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Eat smarter. Save more. Live healthier."
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        animate()
    }

    // MARK: - Layout Setup

    private func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(taglineLabel)

        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),

            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),

            // Tagline
            taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            taglineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            taglineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Animation

    private func animate() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
            self.logoImageView.transform = .identity
            self.titleLabel.alpha = 1
            self.taglineLabel.alpha = 1
        }, completion: { _ in
            self.fadeOutAndNavigate()
        })
    }

    private func fadeOutAndNavigate() {
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
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
}

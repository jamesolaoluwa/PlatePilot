import UIKit

class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PlatePilotLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PlatePilot"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        animate()
    }

    private func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16)
        ])
    }

    private func animate() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
                        self.logoImageView.transform = .identity
                        self.titleLabel.alpha = 1
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
            UIApplication.shared.windows.first?.rootViewController = tabController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
    }
}

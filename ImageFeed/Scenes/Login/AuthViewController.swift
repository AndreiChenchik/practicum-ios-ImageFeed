import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()

        setupLoginButton()
    }

    // MARK: View components
    private let unsplashLogoView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = .asset(.unsplashLogo)
        imageView.tintColor = .asset(.ypWhite)

        return imageView
    }()

    private let loginButton: UIButton = {
        let button = UIButton()

        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .asset(.ysDisplayBold, size: 17)

        button.setTitleColor(.asset(.ypBlack), for: .normal)
        button.backgroundColor = .asset(.ypWhite)

        button.layer.cornerRadius = 16
        button.clipsToBounds = true

        return button
    }()
}

// MARK: - Layout

extension AuthViewController {
    private func layoutComponents() {
        unsplashLogoView.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(unsplashLogoView)
        view.addSubview(loginButton)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            unsplashLogoView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor),
            unsplashLogoView.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor),
            loginButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(
                equalToConstant: 48)
        ])
    }
}

// MARK: - Styling

extension AuthViewController {
    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

// MARK: - Actions

extension AuthViewController {
    private func setupLoginButton() {
        loginButton.addTarget(
            self, action: #selector(loginPressed), for: .touchUpInside)
    }

    @objc private func loginPressed() {
        let loginWebViewVC = OAuthCodeViewController()
        loginWebViewVC.modalPresentationStyle = .overFullScreen

        present(loginWebViewVC, animated: true)
    }
}

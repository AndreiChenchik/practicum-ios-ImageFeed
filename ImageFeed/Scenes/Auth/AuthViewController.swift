import UIKit

final class AuthViewController: UIViewController {
    struct Dependencies {
        let oauth2TokenExtractor: OAuth2TokenExtractor
        var oauthTokenStorage: OAuth2TokenStoring
    }

    private var dep: Dependencies

    init(dep: Dependencies) {
        self.dep = dep
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

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
        let oAuthViewPresenter = OAuthCodePresenter()
        let oAuthCodeVC = OAuthCodeViewController(presenter: oAuthViewPresenter, delegate: self)
        oAuthViewPresenter.view = oAuthCodeVC

        let navigationController = UINavigationController(
            rootViewController: oAuthCodeVC)
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true)
    }
}

// MARK: - OAuthCodeViewControllerDelegate

extension AuthViewController: OAuthCodeViewControllerDelegate {
    func oauthCodeViewController(
        _ oauthCodeVC: OAuthCodeViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()

        oauthCodeVC.dismiss(animated: true)
        dep.oauth2TokenExtractor.fetchAuthToken(
            authCode: code
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()

                switch result {
                case let .success(token):
                    self.dep.oauthTokenStorage.token = token
                    self.dismiss(animated: true)
                case let .failure(error):
                    print(
                        "Can't load user token: \(error.localizedDescription)"
                    )
                }
            }
        }
    }

    func oauthCodeViewControllerDidCancel(
        _ oauthCodeVC: OAuthCodeViewController
    ) {
        oauthCodeVC.dismiss(animated: true)
    }
}

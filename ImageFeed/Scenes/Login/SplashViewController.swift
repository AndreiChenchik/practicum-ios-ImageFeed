import UIKit

final class SplashViewController: UIViewController {

    private let oauth2TokenExtractor: OAuth2TokenExtractor
    private let oauthTokenStorage: OAuth2TokenStoring
    private let profileLoader: ProfileLoader
    private let errorPresenter: ErrorPresenting

    init(
        oauth2TokenExtractor: OAuth2TokenExtractor,
        oauthTokenStorage: OAuth2TokenStoring,
        profileLoader: ProfileLoader,
        errorPresenter: ErrorPresenting
    ) {
        self.oauth2TokenExtractor = oauth2TokenExtractor
        self.oauthTokenStorage = oauthTokenStorage
        self.profileLoader = profileLoader
        self.errorPresenter = errorPresenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let userToken = oauthTokenStorage.token {
            loadApp(with: userToken)
        } else {
            startAuthentification()
        }
    }

    // MARK: View components
    private let practicumLogoView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = .asset(.practicumLogo)
        imageView.tintColor = .asset(.ypWhite)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
}

// MARK: - User Info

extension SplashViewController {
    private func loadApp(with token: String) {
        UIBlockingProgressHUD.show()

        profileLoader.fetchProfile(bearerToken: token) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                defer { UIBlockingProgressHUD.dismiss() }

                switch result {
                case let .success(userProfile):
                    self.navigateToApp(userProfile: userProfile)
                case let .failure(error):
                    self.displayLoadError(error: error)
                }
            }
        }
    }

    private func displayLoadError(error: Error) {
        let errorMessage = error.localizedDescription

        errorPresenter.displayAlert(
            over: self,
            title: "Error!!",
            message: "Something went wrong: \(errorMessage)",
            actionTitle: "OK"
        ) { [weak self] in
            self?.startAuthentification()
        }
    }
}

// MARK: - Navigation

extension SplashViewController {
    private func startAuthentification() {
        let authVC = AuthViewController(
            oauth2TokenExtractor: oauth2TokenExtractor,
            oauthTokenStorage: oauthTokenStorage)

        authVC.modalPresentationStyle = .fullScreen

        present(authVC, animated: true)
    }

    private func navigateToApp(userProfile: UserProfile) {
        let appVC = TabBarController(userProfile: userProfile)

        appVC.modalPresentationStyle = .fullScreen

        present(appVC, animated: true)
    }
}

// MARK: - Layout

extension SplashViewController {
    private func layoutComponents() {
        practicumLogoView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(practicumLogoView)

        NSLayoutConstraint.activate([
            practicumLogoView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            practicumLogoView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            practicumLogoView.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.2),
            practicumLogoView.heightAnchor.constraint(
                equalTo: practicumLogoView.widthAnchor)
        ])
    }
}

// MARK: - Styling

extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

import UIKit

final class SplashViewController: UIViewController {

    let oauth2TokenExtractor: OAuth2TokenExtractor
    let oauthTokenStorage: OAuth2TokenStoring
    let objectService: ObjectLoading

    init(
        oauth2TokenExtractor: OAuth2TokenExtractor,
        oauthTokenStorage: OAuth2TokenStoring,
        objectService: ObjectLoading
    ) {
        self.oauth2TokenExtractor = oauth2TokenExtractor
        self.oauthTokenStorage = oauthTokenStorage
        self.objectService = objectService

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

        navigateUser()
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
    private func navigateUser() {
        guard let token = oauthTokenStorage.token else {
            navigateToAuth()
            return
        }

        UIBlockingProgressHUD.show()

        var url = URL.unsplashBaseURL
        url.appendPathComponent("/me")

        objectService.fetch(
            url: url,
            bearerToken: token
        ) { [weak self] (result: Result<UserProfile, Error>) in
            guard let self else { return }

            DispatchQueue.main.async {
                defer { UIBlockingProgressHUD.dismiss() }

                switch result {

                case let .success(userProfile):
                    self.navigateToApp(userProfile: userProfile)
                case let .failure(error):
                    print(
                        "Can't load user profile: \(error.localizedDescription)"
                    )

                    self.navigateToAuth()
                }
            }
        }
    }
}

// MARK: - Navigation

extension SplashViewController {
    private func navigateToAuth() {
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

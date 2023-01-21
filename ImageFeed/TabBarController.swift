import UIKit

class TabBarController: UITabBarController {
    struct Dependencies {
        let profileViewPresenter: ProfileViewPresenter
        let imagesListViewPresenter: ImagesListViewPresenterProtocol
    }

    private let userProfile: UserProfile
    private let deps: Dependencies

    init(userProfile: UserProfile, deps: Dependencies) {
        self.userProfile = userProfile
        self.deps = deps
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let profileViewController = ProfileViewController(presenter: deps.profileViewPresenter)
        deps.profileViewPresenter.view = profileViewController
        deps.profileViewPresenter.userProfile = userProfile

        let imagesListViewController = ImagesListViewController(
            presenter: deps.imagesListViewPresenter
        )
        deps.imagesListViewPresenter.view = imagesListViewController

        viewControllers = [
            imagesListViewController,
            profileViewController
        ]

        if let listItem = tabBar.items?.first {
            listItem.image = .asset(.listTabIcon)
            listItem.title = ""
        }

        if let profileItem = tabBar.items?.last {
            profileItem.image = .asset(.profileTabIcon)
            profileItem.title = ""
        }
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()

        appearance.backgroundColor = .asset(.ypBlack)
        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = .asset(.ypWhite)
    }
}

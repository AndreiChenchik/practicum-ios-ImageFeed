import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        viewControllers = [
            getImagesNavigationController(),
            ProfileViewController()
        ]

        if let listItem = tabBar.items?[0] {
            listItem.image = .asset(.listTabIcon)
        }

        if let profileItem = tabBar.items?[1] {
            profileItem.image = .asset(.profileTabIcon)
        }
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .asset(.ypBlack)
        tabBar.standardAppearance = appearance

        tabBar.tintColor = .asset(.ypWhite)
    }

    private func getImagesNavigationController() -> UINavigationController {
        let controller = UINavigationController(
            rootViewController: ImagesListViewController()
        )

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .asset(.ypBlack)
        controller.navigationBar.standardAppearance = appearance

        controller.navigationBar.tintColor = .asset(.ypWhite)

        return controller
    }
}

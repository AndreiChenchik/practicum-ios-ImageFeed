import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        viewControllers = [
            ImagesListViewController(),
            ProfileViewController()
        ]

        if let listItem = tabBar.items?[0] {
            listItem.image = .asset(.listTabIcon)
            listItem.title = ""
        }

        if let profileItem = tabBar.items?[1] {
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

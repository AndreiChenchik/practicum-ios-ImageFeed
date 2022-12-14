import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Use this method to optionally configure and attach the UIWindow `window`
        // to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new
        // (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeRootVC()

        self.window = window
        window.makeKeyAndVisible()
    }

    private func makeRootVC() -> UIViewController {
        let cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, directory: nil)
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        let urlSession = URLSession(configuration: configuration)

        let notificateionCenter = NotificationCenter.default

        let networkClient = NetworkClient(urlSession: urlSession)
        let keychainWrapper = KeychainWrapper.standard
        let oauthTokenStorage = OAuth2TokenStorage(
            keychainWrapper: keychainWrapper)
        let modelService = ModelService(networkClient: networkClient)
        let oauth2Service = OAuth2Service(modelLoader: modelService)
        let profileService = ProfileService(modelLoader: modelService)
        let errorPresenter = ErrorPresenter()
        let profileImageService = ProfileImageService(
            notificationCenter: notificateionCenter,
            modelLoader: modelService
        )
        let imagesListService = ImagesListService(
            notificationCenter: notificateionCenter,
            modelService: modelService
        )

        let profileVCDep = ProfileViewController.Dependencies(
            notificationCenter: notificateionCenter,
            profileImageLoader: profileImageService,
            tokenStorage: oauthTokenStorage
        )

        let imagesListVCDep = ImagesListViewController.Dependencies(
            notificationCenter: notificateionCenter,
            imagesListService: imagesListService,
            errorPresenter: errorPresenter
        )

        let tabBarDep = TabBarController.Dependencies(
            profileVCDep: profileVCDep,
            imagesListVCDep: imagesListVCDep
        )

        let authVCDep = AuthViewController.Dependencies(
            oauth2TokenExtractor: oauth2Service,
            oauthTokenStorage: oauthTokenStorage
        )

        let splashViewDep = SplashViewController.Dependencies(
            oauth2TokenExtractor: oauth2Service,
            oauthTokenStorage: oauthTokenStorage,
            profileLoader: profileService,
            profileImageLoader: profileImageService,
            errorPresenter: errorPresenter,
            tabBarDep: tabBarDep,
            authVCDep: authVCDep
        )

        return SplashViewController(dep: splashViewDep)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily
        // discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

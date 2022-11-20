import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        configureCache()
        return true
    }

    private func configureCache() {
        let cache = ImageCache.default

        // Установить лимит в оперативной памяти в 300 MB.
        cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024

        // Установить лимит в оперативной памяти на 150 картинок.
        cache.memoryStorage.config.countLimit = 150

        // Установить лимит дискового кэша в 1 Гб
        cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024

        // Установить лимит на протухание кэша в оперативной памяти на 10 минут.
        // Таким образом картинка будет удаляться через 10 минут.
        cache.memoryStorage.config.expiration = .seconds(600)

        // Установить вечный лимит на протухание дискового кэша.
        // Таким образом закэшированные картинки на диске будут храниться вечно
        // (пока не удалят приложение).
        cache.diskStorage.config.expiration = .never

        // Установить временной интервал очистки кэша в 30 секунд.
        // Каждые 30 секунд будет выполняться проверка и удаление
        // протухших картинок.
        cache.memoryStorage.config.cleanInterval = 30
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

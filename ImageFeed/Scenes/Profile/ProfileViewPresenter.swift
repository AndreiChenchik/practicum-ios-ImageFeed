import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get }
    var userProfile: UserProfile? { get set }

    func logout()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private var dep: Dependencies
    private var profileAvatarObserver: NSObjectProtocol?

    init(dep: Dependencies) {
        self.dep = dep
    }

    deinit {
        stopObservingAvatarChanges()
    }

    // MARK: ProfileViewPresenterProtocol
    weak var view: ProfileViewControllerProtocol?
    var userProfile: UserProfile?

    func logout() {
        dep.logoutHelper.logout()
        dep.tokenStorage.token = nil
        view?.dismiss()
    }

    func viewDidLoad() {
        observeAvatarChanges()

        if let userProfile {
            view?.displayUserData(profile: userProfile)
        }
        updateAvatar()
    }
}

// MARK: - Observe AvatarChanges

extension ProfileViewPresenter {
    private func observeAvatarChanges() {
        profileAvatarObserver = dep.notificationCenter.addObserver(
            forName: dep.profileImageLoader.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }

    private func stopObservingAvatarChanges() {
        if let profileAvatarObserver {
            dep.notificationCenter.removeObserver(profileAvatarObserver)
        }
    }

    private func updateAvatar() {
        guard
            let avatarURLString = dep.profileImageLoader.avatarURLString,
            let avatarURL = URL(string: avatarURLString)
        else { return }

        view?.updateAvatarURL(avatarURL)
    }
}

extension ProfileViewPresenter {
    struct Dependencies {
        let notificationCenter: NotificationCenter
        let profileImageLoader: ProfileImageLoader
        var tokenStorage: OAuth2TokenStoring
        var logoutHelper: LogoutHelperProtocol
    }
}

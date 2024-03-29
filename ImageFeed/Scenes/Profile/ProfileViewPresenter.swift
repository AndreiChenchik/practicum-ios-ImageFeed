import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get }
    var userProfile: UserProfile? { get set }

    func logout()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private var deps: Dependencies
    private var profileAvatarObserver: NSObjectProtocol?

    init(deps: Dependencies) {
        self.deps = deps
    }

    deinit {
        stopObservingAvatarChanges()
    }

    // MARK: ProfileViewPresenterProtocol
    weak var view: ProfileViewControllerProtocol?
    var userProfile: UserProfile?

    func logout() {
        deps.logoutHelper.logout()
        deps.tokenStorage.token = nil
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
        profileAvatarObserver = deps.notificationCenter.addObserver(
            forName: deps.profileImageLoader.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }

    private func stopObservingAvatarChanges() {
        if let profileAvatarObserver {
            deps.notificationCenter.removeObserver(profileAvatarObserver)
        }
    }

    private func updateAvatar() {
        guard
            let avatarURLString = deps.profileImageLoader.avatarURLString,
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

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol = ProfileViewPresenterSpy()

    var isDismissCalled = false

    var userProfile: UserProfile?
    var avatarURL: URL?

    init() {}

    func dismiss() {
        isDismissCalled = true
    }

    func updateAvatarURL(_ url: URL) {
        avatarURL = url
    }

    func displayUserData(profile: ImageFeed.UserProfile) {
        userProfile = profile
    }
}

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var isViewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?

    var userProfile: UserProfile?

    func logout() {}

    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
}

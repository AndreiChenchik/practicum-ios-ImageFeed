@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testControllerCallsViewDidLoad() {
        // given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController

        // when
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = viewController

        // then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }

    func testPresenterSetsProfileOnLoad() {
        // given
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: ProfileImageLoaderMock(),
            tokenStorage: OAuth2TokenStoringMock(),
            logoutHelper: LogoutHelperSpy()
        ))
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController

        // when
        let profileMock = UserProfile(firstName: nil,
                                      lastName: nil,
                                      username: "",
                                      twitterUsername: nil,
                                      instagramUsername: nil,
                                      profileImage: nil)
        presenter.userProfile = profileMock
        presenter.viewDidLoad()

        // then
        XCTAssertEqual(viewController.userProfile, profileMock)
    }

    func testPresenterSetsAvatarOnLoad() {
        // given
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: ProfileImageLoaderMock(),
            tokenStorage: OAuth2TokenStoringMock(),
            logoutHelper: LogoutHelperSpy()
        ))
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertEqual(viewController.avatarURL, URL(string: "http://dummy.com")!)
    }

    func testPresenterUpdatesAvatarOnNewImageLoaded() {
        // given
        let imageLoader = ProfileImageLoaderMock()
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: imageLoader,
            tokenStorage: OAuth2TokenStoringMock(),
            logoutHelper: LogoutHelperSpy()
        ))
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController

        // when
        presenter.viewDidLoad()
        imageLoader.notify()

        // then
        XCTAssertEqual(viewController.avatarURL, URL(string: "http://dummy2.com")!)
    }

    func testPresenterCallsDismissOnLogout() {
        // given
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: ProfileImageLoaderMock(),
            tokenStorage: OAuth2TokenStoringMock(),
            logoutHelper: LogoutHelperSpy()
        ))
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController

        // when
        presenter.logout()

        // then
        XCTAssertTrue(viewController.isDismissCalled)
    }

    func testPresenterClearsTokenOnLogout() {
        // given
        let tokenStorage = OAuth2TokenStoringMock()
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: ProfileImageLoaderMock(),
            tokenStorage: tokenStorage,
            logoutHelper: LogoutHelperSpy()
        ))

        // when
        tokenStorage.token = "something"
        presenter.logout()

        // then
        XCTAssertNil(tokenStorage.token)
    }

    func testPresenterCallsLogoutHelperOnLogout() {
        // given
        let logoutHelper = LogoutHelperSpy()
        let presenter = ProfileViewPresenter(dep: .init(
            notificationCenter: .default,
            profileImageLoader: ProfileImageLoaderMock(),
            tokenStorage: OAuth2TokenStoringMock(),
            logoutHelper: logoutHelper
        ))

        // when
        presenter.logout()

        // then
        XCTAssertTrue(logoutHelper.isLogoutCalled)}
}

@testable import ImageFeed
import XCTest

final class OAuthCodeViewControllerDelegateDummy: OAuthCodeViewControllerDelegate {
    func oauthCodeViewController(
        _ oauthCodeVC: ImageFeed.OAuthCodeViewController,
        didAuthenticateWithCode code: String
    ) {}

    func oauthCodeViewControllerDidCancel(_ oauthCodeVC: ImageFeed.OAuthCodeViewController) {}
}

final class OAuthCodeViewTests: XCTestCase {
    func testVCCallsViewDidLoad() {
        // given
        let presenter = OAuthCodePresenterSpy()
        let viewController = OAuthCodeViewController(
            presenter: presenter,
            delegate: OAuthCodeViewControllerDelegateDummy()
        )
        presenter.view = viewController

        // when
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = viewController

        // then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }

    func testPresenterCallsLoadRequest() {
        // given
        let authHelper = AuthHelper()
        let presenter = OAuthCodeViewPresenter(authHelper: authHelper)
        let viewController = OAuthCodeViewControllerSpy(presenter: presenter)
        presenter.view = viewController

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertTrue(viewController.isLoadCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = OAuthCodeViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = OAuthCodeViewPresenter(authHelper: authHelper)
        let progress: Float = 1

        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        // when
        let url = authHelper.authURL
        let urlString = url.absoluteString

        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!

        // when
        let code = authHelper.getAuthCode(from: url)

        // then
        XCTAssertEqual(code, "test code")
    }
}

@testable import ImageFeed
import XCTest

final class OAuthCodeViewTests: XCTestCase {
    func testVCCallsViewDidLoad() {
        // given
        let presenter = OAuthCodePresenterSpy()
        let viewController = OAuthCodeViewController(presenter: presenter)
        presenter.view = viewController

        // when
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = viewController

        // then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
}

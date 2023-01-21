@testable import ImageFeed
import XCTest

final class ImagesListViewPresenterSpy: NSObject, ImagesListViewPresenterProtocol {
    var isViewDidLoadCalled = false
    func viewDidLoad() { isViewDidLoadCalled = true}

    var view: ImageFeed.ImagesListViewControllerProtocol?
    func imageListCellDidTapLike(
        _ cell: ImageFeed.ImagesListCell,
        completion: @escaping (Bool) -> Void
    ) {}
}

final class ImagesListViewControllerTests: XCTestCase {
    func testPresenterCallesOnViewDidLoad() {
        // given
        let presenter = ImagesListViewPresenterSpy()
        let viewController = ImagesListViewController(presenter: presenter)
        presenter.view = viewController

        // when
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = viewController

        // then
        XCTAssertTrue(presenter.isViewDidLoadCalled)
    }
}

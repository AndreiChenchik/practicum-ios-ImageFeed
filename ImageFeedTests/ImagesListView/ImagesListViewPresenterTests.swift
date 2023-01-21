@testable import ImageFeed
import XCTest

final class ImagesListViewPresenterTests: XCTestCase {
    func testDataSourceViewDidLoadCalled() {
        // given
        let spy = ImagesListViewDataSourceSpy()
        let errorPresenter = ErrorPresenterDummy()
        let sut = ImagesListViewPresenter(deps: .init(
            dataSource: spy,
            errorPresenter: errorPresenter,
            singleImageVCDep: .init(fileManager: .default, errorPresenter: errorPresenter)
        ))
        let view = ImagesListViewControllerDummy()
        sut.view = view

        // when
        sut.viewDidLoad()

        // then
        XCTAssertEqual(spy.isViewDidLoadCalled, true)
    }

    func testTableViewSetupCompleted() {
        // given
        let spy = ImagesListViewDataSourceSpy()
        let errorPresenter = ErrorPresenterDummy()
        let sut = ImagesListViewPresenter(deps: .init(
            dataSource: spy,
            errorPresenter: errorPresenter,
            singleImageVCDep: .init(fileManager: .default, errorPresenter: errorPresenter)
        ))
        let view = ImagesListViewControllerDummy()
        sut.view = view

        // when
        sut.viewDidLoad()

        // then
        XCTAssertTrue(view.tableView.delegate === sut)
        XCTAssertTrue(view.tableView.dataSource === spy)
        XCTAssertTrue(spy.tableView === view.tableView)
    }

    func testChangeLikePassedToDataSource() {
        // given
        let spy = ImagesListViewDataSourceSpy()
        let errorPresenter = ErrorPresenterDummy()
        let sut = ImagesListViewPresenter(deps: .init(
            dataSource: spy,
            errorPresenter: errorPresenter,
            singleImageVCDep: .init(fileManager: .default, errorPresenter: errorPresenter)
        ))
        let view = ImagesListViewControllerDummy()
        sut.view = view

        // when
        sut.viewDidLoad()
        sut.view?.tableView.rowHeight = 10
        let cell = sut.view?.tableView.dequeueReusableCell(
            withIdentifier: "\(ImagesListCell.self)",
            for: .init(row: 0, section: 0)
        )
        // swiftlint:disable:next force_cast
        sut.imageListCellDidTapLike(cell as! ImagesListCell) { _ in }

        // then
        XCTAssertEqual(spy.isChangeLikeCalled, true)
    }

    func testRowHeightCalculation() {
        // given
        let spy = ImagesListViewDataSourceSpy()
        let errorPresenter = ErrorPresenterDummy()
        let sut = ImagesListViewPresenter(deps: .init(
            dataSource: spy,
            errorPresenter: errorPresenter,
            singleImageVCDep: .init(fileManager: .default, errorPresenter: errorPresenter)
        ))
        let view = ImagesListViewControllerDummy()
        sut.view = view

        // when
        sut.viewDidLoad()
        let height = sut.tableView(sut.view!.tableView, heightForRowAt: .init(row: 0, section: 0))
        let viewWidth = sut.view!.view.frame.width - 32 // tableview padding = 32

        // then
        XCTAssertEqual(height - 8, viewWidth)
    }

    func testCellTapPresentView() {
        // given
        let spy = ImagesListViewDataSourceSpy()
        let errorPresenter = ErrorPresenterDummy()
        let sut = ImagesListViewPresenter(deps: .init(
            dataSource: spy,
            errorPresenter: errorPresenter,
            singleImageVCDep: .init(fileManager: .default, errorPresenter: errorPresenter)
        ))
        let view = ImagesListViewControllerDummy()
        sut.view = view

        // when
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = view
        sut.tableView(sut.view!.tableView, didSelectRowAt: .init(row: 0, section: 0))

        // then
        XCTAssertNotNil(view.presentedViewController)
    }
}

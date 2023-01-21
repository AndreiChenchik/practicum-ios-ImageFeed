@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testSetsTokenForRequests() {
        // given
        let spy = ModelLoadingSpy()
        let service = ImagesListService(notificationCenter: .default, modelService: spy)

        // when
        service.authorize(with: "token")
        service.prepareForDisplay(index: 10)

        // then
        XCTAssertEqual(spy.authHeader?.contains("token"), true)
    }

    func testFetchCalledOnPrepareForDisplay() {
        // given
        let spy = ModelLoadingSpy()
        let service = ImagesListService(notificationCenter: .default, modelService: spy)

        // when
        service.authorize(with: "token")
        service.prepareForDisplay(index: 10)

        // then
        XCTAssertEqual(spy.isFetchCalled, true)
    }

    func testNotificationOnFetch() {
        // given
        let spy = ModelLoadingSpy()
        let service = ImagesListService(notificationCenter: .default, modelService: spy)

        let expectation = XCTestExpectation(description: "Wait for notification")
        let observer = NotificationCenter.default.addObserver(
            forName: service.didChangeNotification,
            object: nil,
            queue: nil
        ) { _ in
            expectation.fulfill()
        }

        // when
        service.authorize(with: "token")
        service.prepareForDisplay(index: 1)

        // then
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }

    func testPhotoFetched() {
        // given
        let spy = ModelLoadingSpy()
        let service = ImagesListService(notificationCenter: .default, modelService: spy)

        let expectation = XCTestExpectation(description: "Wait for notification")
        let observer = NotificationCenter.default.addObserver(
            forName: service.didChangeNotification,
            object: nil,
            queue: nil
        ) { _ in
            expectation.fulfill()
        }

        // when
        XCTAssertEqual(service.photos.count, 0)

        service.authorize(with: "token")
        service.prepareForDisplay(index: 1)

        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(service.photos.count, 1)

        NotificationCenter.default.removeObserver(observer)
    }

    func testChangeLikeCalled() {
        // given
        let spy = ModelLoadingSpy()
        let service = ImagesListService(notificationCenter: .default, modelService: spy)

        let expectation = XCTestExpectation(description: "Wait for notification")
        let observer = NotificationCenter.default.addObserver(
            forName: service.didChangeNotification,
            object: nil,
            queue: nil
        ) { _ in
            expectation.fulfill()
        }

        // when
        service.authorize(with: "token")
        service.prepareForDisplay(index: 1)
        wait(for: [expectation], timeout: 1.0)
        service.changeLike(index: 0, isLiked: false) { _ in }

        // then
        XCTAssertEqual(
            spy.urlCalled?.absoluteString,
            "https://api.unsplash.com/photos/Cy5dya5MAlI/like"
        )

        NotificationCenter.default.removeObserver(observer)
    }
}

@testable import ImageFeed
import UIKit

extension Photo {
    static var mock: Self {
        .init(
            id: "photo1",
            description: nil,
            thumbnailImage: .init(string: "https://ya.ru")!,
            largeImage: .init(string: "https://ya.ru")!,
            size: .zero,
            createdAt: .now,
            isLiked: false
        )
    }
}

final class ImagesListViewDataSourceSpy: NSObject, ImagesListViewDataSourceProtocol {
    var isViewDidLoadCalled = false
    var isChangeLikeCalled = false

    var tableView: UITableView?
    var cellDelegate: ImageFeed.ImagesListCellDelegate?

    func viewDidLoad() { isViewDidLoadCalled = true }
    func prepareForDisplay(index: Int) {}
    func getPhoto(at index: Int) -> Photo { .mock }
    func changeLike(index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        isChangeLikeCalled = true
    }

    func photoSize(index: Int) -> CGSize { .init(width: 100, height: 100) }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
}

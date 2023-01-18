import UIKit

final class ImagesListViewDataSource: NSObject {
    weak var cellDelegate: ImagesListCellDelegate?

    private let imagesListService: ImagesListService
    var photos: [Photo] { imagesListService.photos }

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }
}

// MARK: - Image actions

extension ImagesListViewDataSource {
    func changeLike(index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        imagesListService.changeLike(
            index: index,
            isLiked: !imagesListService.photos[index].isLiked,
            completion: completion
        )
    }

    func photoSize(index: Int) -> CGSize {
        imagesListService.photos[index].size
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewDataSource: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return imagesListService.photos.count
    }

    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ImagesListCell.self)", for: indexPath)

        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("Can't get cell for ImagesList")
        }

        let viewModel = convert(model: imagesListService.photos[indexPath.row])
        imagesListCell.configure(with: viewModel)

        imagesListCell.delegate = cellDelegate

        return imagesListCell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        imagesListService.prepareForDisplay(index: indexPath.row)
    }
}

// MARK: - Helpers

private extension ImagesListViewDataSource {
    func convert(model: Photo) -> ImageViewModel {
        let dateString = dateFormatter.string(from: model.createdAt)

        return ImageViewModel(
            image: model.thumbnailImage,
            size: model.size,
            dateString: dateString,
            isFavorite: model.isLiked
        )
    }
}

import UIKit

protocol ImagesListViewDataSourceProtocol: UITableViewDataSource {
    var tableView: UITableView? { get set }
    var cellDelegate: ImagesListCellDelegate? { get set }

    func viewDidLoad()
    func prepareForDisplay(index: Int)

    func getPhoto(at index: Int) -> Photo
    func changeLike(index: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func photoSize(index: Int) -> CGSize
}

final class ImagesListViewDataSource: NSObject {
    private let deps: Dependencies
    private var imagesListObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    init(deps: Dependencies) {
        self.deps = deps
    }

    deinit {
        stopObservingImagesListChanges()
    }

    // MARK: ImagesListViewDataSourceProtocol

    weak var tableView: UITableView?
    weak var cellDelegate: ImagesListCellDelegate?
}

// MARK: - Dependencies

extension ImagesListViewDataSource {
    struct Dependencies {
        let notificationCenter: NotificationCenter
        let imagesListService: ImagesListService
    }
}

// MARK: - ImagesListViewDataSourceProtocol

extension ImagesListViewDataSource: ImagesListViewDataSourceProtocol {
    func viewDidLoad() {
        startObservingImagesListChanges()
    }

    func prepareForDisplay(index: Int) {
        deps.imagesListService.prepareForDisplay(index: index)
    }

    func getPhoto(at index: Int) -> Photo {
        deps.imagesListService.photos[index]
    }

    func changeLike(index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        deps.imagesListService.changeLike(
            index: index,
            isLiked: !deps.imagesListService.photos[index].isLiked,
            completion: completion
        )
    }

    func photoSize(index: Int) -> CGSize {
        deps.imagesListService.photos[index].size
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewDataSource: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int
    ) -> Int {
        return deps.imagesListService.photos.count
    }

    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ImagesListCell.self)", for: indexPath)

        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("Can't get cell for ImagesList")
        }

        let viewModel = ImageViewModel(
            model: deps.imagesListService.photos[indexPath.row],
            dateFormatter: dateFormatter
        )

        imagesListCell.configure(with: viewModel)

        imagesListCell.delegate = cellDelegate

        return imagesListCell
    }
}

// MARK: - On ImagesList Changes

private extension ImagesListViewDataSource {
    func startObservingImagesListChanges() {
        imagesListObserver = deps.notificationCenter.addObserver(
            forName: deps.imagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }

    func stopObservingImagesListChanges() {
        if let imagesListObserver {
            deps.notificationCenter.removeObserver(imagesListObserver)
        }
    }

    func updateTableViewAnimated() {
        guard let tableView else { return }

        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = deps.imagesListService.photos.count

        if oldCount < newCount {
            let newPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }

            tableView.performBatchUpdates {
                tableView.insertRows(at: newPaths, with: .automatic)
            }
        }
    }
}

// MARK: - Helpers

private extension ImageViewModel {
    init(model: Photo, dateFormatter: DateFormatter) {
        let dateString = dateFormatter.string(from: model.createdAt)

        image = model.thumbnailImage
        size = model.size
        self.dateString = dateString
        isFavorite =  model.isLiked
    }
}

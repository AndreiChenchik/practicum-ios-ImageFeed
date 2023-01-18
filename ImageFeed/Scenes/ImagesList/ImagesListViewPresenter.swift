import UIKit

protocol ImagesListViewPresenterProtocol: UITableViewDelegate, ImagesListCellDelegate {
    var view: ImagesListViewControllerProtocol? { get set }
    var dataSource: UITableViewDataSource { get }
    func viewDidLoad()
}

final class ImagesListViewPresenter: NSObject, ImagesListViewPresenterProtocol {
    private let deps: Dependencies

    weak var view: ImagesListViewControllerProtocol?
    private var imagesListObserver: NSObjectProtocol?

    var dataSource: UITableViewDataSource { deps.dataSource }

    init(deps: Dependencies) {
        self.deps = deps
        super.init()
    }

    deinit {
        stopObservingImagesListChanges()
    }

    func viewDidLoad() {
        observeImagesListChanges()
    }

    private lazy var singleImageView: SingleImageViewController = {
        let controller = SingleImageViewController(deps: deps.singleImageVCDep)

        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen

        return controller
    }()
}

// MARK: - Dependencies

extension ImagesListViewPresenter {
    struct Dependencies {
        let notificationCenter: NotificationCenter
        let dataSource: ImagesListViewDataSource
        let errorPresenter: ErrorPresenting
        let singleImageVCDep: SingleImageViewController.Dependencies
    }
}

// MARK: - On ImagesList Changes

private extension ImagesListViewPresenter {
    func observeImagesListChanges() {
        imagesListObserver = deps.notificationCenter.addObserver(
            forName: ImagesListService.didChangeNotification,
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
        guard let view else { return }
        let oldCount = view.tableView.numberOfRows(inSection: 0)
        let newCount = deps.dataSource.photos.count

        if oldCount < newCount {
            let newPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }

            view.tableView.performBatchUpdates {
                view.tableView.insertRows(at: newPaths, with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewPresenter: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let photo = deps.dataSource.photos[indexPath.row]
        singleImageView.image = .init(image: photo.largeImage, size: photo.size)

        view?.present(singleImageView, animated: true)
    }

    #warning("To improve after Practicum Authors Team clarifies the assignment")
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = deps.dataSource.photoSize(index: indexPath.row)
        let aspectRatio = imageSize.height / imageSize.width

        let cellWidth = view!.view.frame.width - 32
        let cellHeight = cellWidth * aspectRatio + 8

        return cellHeight
    }
}

// MARK: - ImagesListCellDelegate, On Cell tap

extension ImagesListViewPresenter: ImagesListCellDelegate {
    func imageListCellDidTapLike(
        _ cell: ImagesListCell,
        completion: @escaping (Bool) -> Void
    ) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }

        UIBlockingProgressHUD.show()
        deps.dataSource.changeLike(index: indexPath.row) { [weak self] result in
            defer { UIBlockingProgressHUD.dismiss() }

            guard let self, let view = self.view else { return }

            switch result {
            case let .success(isLiked):
                completion(isLiked)
            case let .failure(error):
                self.deps.errorPresenter.displayAlert(
                    over: view,
                    title: error.localizedDescription,
                    actionTitle: "OK"
                )
            }

        }
    }
}

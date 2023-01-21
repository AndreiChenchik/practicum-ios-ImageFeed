import UIKit

protocol ImagesListViewPresenterProtocol: UITableViewDelegate, ImagesListCellDelegate {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ImagesListViewPresenter: NSObject, ImagesListViewPresenterProtocol {
    private let deps: Dependencies
    weak var view: ImagesListViewControllerProtocol?

    init(deps: Dependencies) {
        self.deps = deps
        super.init()
    }

    func viewDidLoad() {
        configureTable()
        deps.dataSource.viewDidLoad()
    }

    func configureTable() {
        guard let view else {
            assertionFailure("Then who is calling for configure?")
            return
        }

        view.tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: "\(ImagesListCell.self)")

        view.tableView.delegate = self
        view.tableView.dataSource = deps.dataSource
        deps.dataSource.tableView = view.tableView
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
        let dataSource: ImagesListViewDataSourceProtocol
        let errorPresenter: ErrorPresenting
        let singleImageVCDep: SingleImageViewController.Dependencies
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewPresenter: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let photo = deps.dataSource.getPhoto(at: indexPath.row)

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

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        deps.dataSource.prepareForDisplay(index: indexPath.row)
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

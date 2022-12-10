import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    struct Dependencies {
        let notificationCenter: NotificationCenter
        let imagesListService: ImagesListService
        let errorPresenter: ErrorPresenting
    }

    private let deps: Dependencies
    private var imagesListObserver: NSObjectProtocol?

    init(deps: Dependencies) {
        self.deps = deps
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        stopObservingImagesListChanges()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()

        observeImagesListChanges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Components

    private let tableView: UITableView = {
        let tableView = UITableView()

        tableView.contentInset =  UIEdgeInsets(
            top: 16, left: 0, bottom: 0, right: 0
        )

        return tableView
    }()

    private lazy var singleImageView: SingleImageViewController = {
        let controller = SingleImageViewController()

        controller.hidesBottomBarWhenPushed = true
        controller.modalPresentationStyle = .fullScreen

        return controller
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

// MARK: - Styling

extension ImagesListViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func configureView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

// MARK: - UITableView

extension ImagesListViewController {
    private func configureTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: "\(ImagesListCell.self)")

        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        let photo = deps.imagesListService.photos[indexPath.row]
        singleImageView.image = .init(image: photo.largeImage, size: photo.size)

        present(singleImageView, animated: true)
    }

    #warning("To improve after Practicum Authors Team clarifies the assignment")
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = convert(model: deps.imagesListService.photos[indexPath.row]).size
        let aspectRatio = imageSize.height / imageSize.width

        let cellWidth = view.frame.width - 32
        let cellHeight = cellWidth * aspectRatio + 8

        return cellHeight
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
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

        let viewModel = convert(model: deps.imagesListService.photos[indexPath.row])
        imagesListCell.configure(with: viewModel)

        imagesListCell.delegate = self

        return imagesListCell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        deps.imagesListService.prepareForDisplay(index: indexPath.row)
    }

    private func convert(model: Photo) -> ImageViewModel {
        let dateString = dateFormatter.string(from: model.createdAt)

        return ImageViewModel(
            image: model.thumbnailImage,
            size: model.size,
            dateString: dateString,
            isFavorite: model.isLiked
        )
    }
}

// MARK: - Observe ImagesList Changes

extension ImagesListViewController {
    private func observeImagesListChanges() {
        imagesListObserver = deps.notificationCenter.addObserver(
            forName: deps.imagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }

    private func stopObservingImagesListChanges() {
        if let imagesListObserver {
            deps.notificationCenter.removeObserver(imagesListObserver)
        }
    }

    private func updateTableViewAnimated() {
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

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(
        _ cell: ImagesListCell,
        completion: @escaping (Bool) -> Void
    ) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = deps.imagesListService.photos[indexPath.row]

        UIBlockingProgressHUD.show()
        deps.imagesListService.changeLike(
            index: indexPath.row,
            isLiked: !photo.isLiked
        ) { [weak self] result in
            defer { UIBlockingProgressHUD.dismiss() }

            guard let self else { return }

            switch result {
            case let .success(isLiked):
                completion(isLiked)
            case let .failure(error):
                self.deps.errorPresenter.displayAlert(
                    over: self,
                    title: error.localizedDescription,
                    actionTitle: "OK"
                )
            }

        }
    }
}

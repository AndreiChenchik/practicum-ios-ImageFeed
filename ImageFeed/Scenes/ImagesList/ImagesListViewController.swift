import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    private let mockData: [Photo] = {
        (0...21)
            .map { _ in (Int.random(in: 100...800), Int.random(in: 100...800)) }
            .map { width, height in
                let thumbnailImage = URL(string: "https://picsum.photos/\(width)/\(height)")!
                let largeImage = URL(string: "https://picsum.photos/\(width*4)/\(height*4)")!
                let imageSize = CGSize(width: width*4, height: height*4)

                return Photo(
                    id: UUID().uuidString,
                    description: nil,
                    thumbnailImage: thumbnailImage,
                    largeImage: largeImage,
                    size: imageSize,
                    createdAt: Date(),
                    isLiked: Bool.random()
                )
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()

        updateInsets() // Imitate scroll position showed in design
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Components

    private let tableView = UITableView()

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

    private func updateInsets() {
        tableView.contentInset =  UIEdgeInsets(
            top: 16, left: 0, bottom: 0, right: 0
        )
        tableView.scrollToRow(
            at: IndexPath(row: 0, section: 0), at: .top, animated: false
        )
    }

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

        let photo = mockData[indexPath.row]
        singleImageView.image = .init(image: photo.largeImage, size: photo.size)

        present(singleImageView, animated: true)
    }

    #warning("To improve after Practicum Authors Team clarifies the assignment")
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = convert(model: mockData[indexPath.row]).size
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
        print("how many?")
        return mockData.count
    }

    func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ImagesListCell.self)", for: indexPath)

        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("Can't get cell for ImagesList")
        }

        let viewModel = convert(model: mockData[indexPath.row])
        imagesListCell.configure(with: viewModel)

        return imagesListCell
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

import UIKit

class ImagesListViewController: UIViewController {
    private let mockData: [Picture] = {
        (0...21).map { num in
            Picture(
                path: "\(num).png",
                date: Date(),
                isFavorite: num % 2 == 1
            )
        }
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTable()

        updateInsets() // Imitate scroll position showed in design
    }
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
        view.backgroundColor = UIColor(colorAsset: .background)
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
    }

    #warning("Move that calculation to ImageListCell somehow")
    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let imageSize = convert(model: mockData[indexPath.row]).image.size
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
        mockData.count
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

    private func convert(model: Picture) -> ImageViewModel {
        let image = UIImage(named: model.path) ?? .remove

        let dateString = dateFormatter.string(from: model.date)

        return ImageViewModel(
            image: image, dateString: dateString, isFavorite: model.isFavorite
        )
    }
}

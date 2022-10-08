import UIKit

class ImagesListViewController: UIViewController {

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
        tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: true)
    }

    let mockData: [Picture] = {
        (0...20).map { num in
            Picture(
                path: "\(num).png",
                date: Date(),
                isFavorite: .random()
            )
        }
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func setupView() {
        view.backgroundColor = UIColor(colorAsset: .background)
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        tableView.register(
            ImagesListCell.self,
            forCellReuseIdentifier: "\(ImagesListCell.self)")

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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

        configCell(for: imagesListCell)
        let viewModel = convert(model: mockData[indexPath.row])
        imagesListCell.configure(with: viewModel)

        return imagesListCell
    }


    private func convert(model: Picture) -> ImageViewModel {
        let image = UIImage(named: model.path) ?? .remove

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: model.date)

        return ImageViewModel(
            image: image, dateString: dateString, isFavorite: model.isFavorite
        )
    }

    private func configCell(for cell: ImagesListCell) { }
}

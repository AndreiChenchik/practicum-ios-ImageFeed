import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: UIViewController {
    var tableView: UITableView { get }
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private var presenter: ImagesListViewPresenterProtocol

    init(presenter: ImagesListViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutTableView()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Components

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.contentInset =  UIEdgeInsets(
            top: 16, left: 0, bottom: 0, right: 0
        )

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        return tableView
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
    private func layoutTableView() {
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

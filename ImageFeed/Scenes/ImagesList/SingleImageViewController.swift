import UIKit

class SingleImageViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupImageView()

        imageView.image = UIImage(named: "11")
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
}

// MARK: - Layout

extension SingleImageViewController {
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Styling

extension SingleImageViewController {
    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

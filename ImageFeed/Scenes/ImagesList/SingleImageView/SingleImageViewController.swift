import UIKit

final class SingleImageViewController: UITabBarController {

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupImageView()
        setupBackButton()

        activateBackButton()

        imageView.image = UIImage(named: "11")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        imageView.image = image
    }

    // MARK: Components

    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let backButton: UIButton = {
        let button = UIButton()

        button.setImage(.asset(.backIcon), for: .normal)
        button.tintColor = .white

        return button
    }()
}

// MARK: - Styling

extension SingleImageViewController {
    private func activateBackButton() {
        backButton.addTarget(
            self, action: #selector(backPressed), for: .touchUpInside)
    }

    @objc private func backPressed() {
        dismiss(animated: true)
    }
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

    private func setupBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 9)
        ])
    }
}

// MARK: - Styling

extension SingleImageViewController {
    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

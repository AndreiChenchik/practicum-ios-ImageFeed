import UIKit

final class SingleImageViewController: UITabBarController {

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        setupScrollView()
        setupBackButton()

        layoutImageView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let image { displayImage(image) }
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

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()

        scroll.backgroundColor = .asset(.ypBlack)

        return scroll
    }()
}

extension SingleImageViewController {
    private func setupBackButton() {
        layoutBackButton()
        backButton.addTarget(
            self, action: #selector(backPressed), for: .touchUpInside)
    }

    private func setupScrollView() {
        scrollView.delegate = self

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

        layoutScrollView()
    }
}

// MARK: - Actions

extension SingleImageViewController {
    private func displayImage(_ image: UIImage) {
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }

    @objc private func backPressed() {
        dismiss(animated: true)
    }
}

// MARK: - Layout

extension SingleImageViewController {
    private func layoutScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }

    private func layoutImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(imageView)

        let scrollGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: scrollGuide.topAnchor),
            imageView.leadingAnchor.constraint(
                equalTo: scrollGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(
                equalTo: scrollGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(
                equalTo: scrollGuide.bottomAnchor)
        ])
    }

    private func layoutBackButton() {
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

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        let containerSize = view.bounds.size
        let imageSize = image.size

        let hScale = containerSize.width / imageSize.width
        let vScale = containerSize.height / imageSize.height

        let scale = min(maxZoomScale,
                        max(
                            minZoomScale,
                            max(hScale, vScale)))

        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let newContentSize = scrollView.contentSize
        let xVal = (newContentSize.width - containerSize.width) / 2
        let yVal = (newContentSize.height - containerSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: xVal, y: yVal), animated: false)
    }
}

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UITabBarController {

    var image: SingleImageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        setupScrollView()
        setupBackButton()
        setupShareButton()

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

    private let shareButton: UIButton = {
        let button = UIButton()

        button.setImage(.asset(.shareIcon), for: .normal)

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

    private func setupShareButton() {
        layoutShareButton()
        shareButton.addTarget(
            self, action: #selector(sharePressed), for: .touchUpInside)
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
    private func displayImage(_ model: SingleImageViewModel) {
        let placeholderImage = UIImage.asset(.placeholderImageView)
        rescaleAndCenterImageInScrollView(imageSize: placeholderImage.size)

        ProgressHUD.show()

        imageView.kf.setImage(
            with: model.image,
            placeholder: placeholderImage
        ) { [weak self] _ in
            ProgressHUD.dismiss()
            self?.rescaleAndCenterImageInScrollView(imageSize: model.size)
        }
    }

    @objc private func backPressed() {
        dismiss(animated: true)
    }

    @objc private func sharePressed() {
        if let image {
            let activity = UIActivityViewController(
                activityItems: [image], applicationActivities: nil)

            present(activity, animated: true)
        }
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
                equalTo: safeArea.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 16)
        ])
    }

    private func layoutShareButton() {
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(shareButton)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            shareButton.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor),
            shareButton.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Styling

extension SingleImageViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func rescaleAndCenterImageInScrollView(imageSize: CGSize) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        let containerSize = view.bounds.size

        let hScale = containerSize.width / imageSize.width
        let vScale = containerSize.height / imageSize.height

        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))

        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let newContentSize = scrollView.contentSize
        let xVal = (newContentSize.width - containerSize.width) / 2
        let yVal = (newContentSize.height - containerSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: xVal, y: yVal), animated: false)
    }
}

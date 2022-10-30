import UIKit

final class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()
        renderMockData()
    }

    // MARK: View components
    private let userPicView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()

        label.font = .asset(.ysDisplayBold, size: 23)
        label.textColor = .asset(.ypWhite)

        return label
    }()

    private let userHandlerLabel: UILabel = {
        let label = UILabel()

        label.font = .asset(.ysDisplayRegular, size: 13)
        label.textColor = .asset(.ypGrey)

        return label
    }()

    private let userDescriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .asset(.ysDisplayRegular, size: 13)
        label.textColor = .asset(.ypWhite)

        return label
    }()

    private let logoutButton: UIButton = {
        let button = UIButton()

        button.setImage(.asset(.logoutIcon), for: .normal)
        button.tintColor = .asset(.ypRed)

        return button
    }()
}

// MARK: - Layout

extension ProfileViewController {
    private func layoutComponents() {
        let vStack = UIStackView()

        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vStack)

        let hStack = UIStackView()
        let hStackMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)

        hStack.layoutMargins = hStackMargins
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        hStack.addArrangedSubview(userPicView)
        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(logoutButton)

        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(userNameLabel)
        vStack.addArrangedSubview(userHandlerLabel)
        vStack.addArrangedSubview(userDescriptionLabel)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 32),
            vStack.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor, constant: -16),
            hStack.widthAnchor.constraint(
                equalTo: vStack.widthAnchor)
        ])
    }
}

// MARK: - Styling

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

// MARK: - Data

extension ProfileViewController {
    private func renderMockData() {
        userPicView.image = .asset(.mockUserPic)
        userNameLabel.text = "Екатерина Новикова"
        userHandlerLabel.text = "@ekaterina_nov"
        userDescriptionLabel.text = "Hello, world!"
    }
}

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    struct Dependencies {
        let notificationCenter: NotificationCenter
        let profileImageLoader: ProfileImageLoader
    }

    private let userProfile: UserProfile
    private let dep: Dependencies

    private var profileAvatarObserver: NSObjectProtocol?

    init(userProfile: UserProfile, dep: Dependencies) {
        self.userProfile = userProfile
        self.dep = dep
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()
        setupActions()

        observeAvatarChanges()
        displayUserData()
    }

    // MARK: View components
    private let userPicView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .cyan

        imageView.image = .asset(.placeholderUserPic)

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

// MARK: - Actions

extension ProfileViewController {
    private func setupActions() {
        logoutButton.addTarget(
            self,
            action: #selector(logoutPressed),
            for: .touchUpInside
        )
    }

    @objc private func logoutPressed() {
        // Temporary function to help with login testing
        KeychainWrapper.standard.removeObject(forKey: .key(.tokenDefaultsKey))
        tabBarController?.dismiss(animated: true)
    }
}

// MARK: - Observe AvatarChanges

extension ProfileViewController {
    private func observeAvatarChanges() {
        profileAvatarObserver = dep.notificationCenter.addObserver(
            forName: dep.profileImageLoader.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatar()
        }
    }
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
                equalTo: vStack.widthAnchor),
            userPicView.widthAnchor.constraint(
                equalToConstant: 70),
            userPicView.heightAnchor.constraint(
                equalTo: userPicView.widthAnchor)
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
    private func updateAvatar() {
        guard
            let avatarURLString = dep.profileImageLoader.avatarURLString,
            let avatarURL = URL(string: avatarURLString)
        else { return }

        userPicView.kf.setImage(
            with: avatarURL,
            placeholder: UIImage.asset(.placeholderUserPic)
        )
    }

    private func displayUserData() {
        userNameLabel.text = userProfile.fullName
        userHandlerLabel.text = userProfile.handler
        userDescriptionLabel.text = "Hello, Unsplash!"
        updateAvatar()
    }
}

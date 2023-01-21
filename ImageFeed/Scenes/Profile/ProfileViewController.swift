import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get }

    func dismiss()
    func updateAvatarURL(_ url: URL)
    func displayUserData(profile: UserProfile)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureComponents()
        setupActions()

        presenter.viewDidLoad()
    }

    // MARK: ProfileViewControllerProtocol
    let presenter: ProfileViewPresenterProtocol

    func dismiss() {
        tabBarController?.dismiss(animated: true)
    }

    func updateAvatarURL(_ url: URL) {
        gradient.removeFromSuperlayer()
        userPicView.kf.indicatorType = .custom(indicator: GradientKFIndicator())
        userPicView.kf.setImage(with: url)
    }

    func displayUserData(profile: UserProfile) {
        userNameLabel.text = profile.fullName
        userHandlerLabel.text = profile.handler
        userDescriptionLabel.text = "Hello, Unsplash!"
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

    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true

        return gradient
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
        presenter.logout()
    }
}

// MARK: - Layout

extension ProfileViewController {
    private func configureComponents() {
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

        userPicView.layer.addSublayer(gradient)
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
}

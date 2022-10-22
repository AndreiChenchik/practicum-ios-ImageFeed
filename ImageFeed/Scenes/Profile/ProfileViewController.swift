//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 22/10/22.
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
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

        button.setImage(.asset(.exitIcon), for: .normal)
        button.tintColor = .asset(.ypRed)
        
        return button
    }()

    private let vStack = {
        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading

        return stack
    }()

    private let hStack = {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center

        return stack
    }()
}

// MARK: - Layout

extension ProfileViewController {
    private func setupLayout() {
        vStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(vStack)

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

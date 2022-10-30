//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 30/10/22.
//

import UIKit

final class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()
    }

    // MARK: View components
    private let practicumLogoView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = .asset(.practicumLogo)
        imageView.tintColor = .asset(.ypWhite)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
}

// MARK: - Layout

extension SplashViewController {
    private func layoutComponents() {
        practicumLogoView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(practicumLogoView)

        NSLayoutConstraint.activate([
            practicumLogoView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            practicumLogoView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            practicumLogoView.widthAnchor.constraint(
                equalTo: view.widthAnchor, multiplier: 0.2),
            practicumLogoView.heightAnchor.constraint(
                equalTo: practicumLogoView.widthAnchor)
        ])
    }
}

// MARK: - Styling

extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private func setupView() {
        view.backgroundColor = .asset(.ypBlack)
    }
}

//
//  ErrorPresenter.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 19/11/22.
//

import UIKit

protocol ErrorPresenting {
    func displayAlert(
        over viewController: UIViewController,
        title: String,
        message: String?,
        actionTitle: String,
        onDismiss: @escaping () -> Void
    )
}

extension ErrorPresenting {
    func displayAlert(
        over viewController: UIViewController,
        title: String,
        actionTitle: String,
        onDismiss: @escaping () -> Void = { }
    ) {
        displayAlert(
            over: viewController,
            title: title,
            message: nil,
            actionTitle: actionTitle,
            onDismiss: onDismiss
        )
    }
}

struct ErrorPresenter: ErrorPresenting {
    func displayAlert(
        over viewController: UIViewController,
        title: String,
        message: String?,
        actionTitle: String,
        onDismiss: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let dismissAction = UIAlertAction(
            title: actionTitle,
            style: .default
        ) { _ in
            onDismiss()
        }
        alert.addAction(dismissAction)

        viewController.present(alert, animated: true)
    }
}

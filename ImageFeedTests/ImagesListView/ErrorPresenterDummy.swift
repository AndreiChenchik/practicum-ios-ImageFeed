@testable import ImageFeed
import UIKit

final class ErrorPresenterDummy: ErrorPresenting {
    func displayAlert(
        over viewController: UIViewController,
        title: String, message: String?,
        actionTitle: String,
        onDismiss: @escaping () -> Void
    ) {}
}

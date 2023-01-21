import Kingfisher
import UIKit

final class GradientKFIndicator: Indicator {
    var view: UIView { gradientView }

    var gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.configureForLoader()

        return gradientView
    }()

    func startAnimatingView() {
        gradientView.animateLoader()
        view.isHidden = false
    }

    func stopAnimatingView() {
        gradientView.stopAnimationLoader()
        view.isHidden = true
    }
}

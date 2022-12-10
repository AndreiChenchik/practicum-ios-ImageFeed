import UIKit
import Kingfisher
import ProgressHUD

struct ImageLoadingIndicator: Indicator {
    var view: UIView { progressHud }
    let progressHud = ProgressHUD()

    func startAnimatingView() { progressHud.show() }
    func stopAnimatingView() { progressHud.dismiss() }

    init() {}
}

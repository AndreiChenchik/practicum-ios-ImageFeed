import UIKit

class WebViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Styling

extension WebViewViewController {
    private func setupView() {
        view.backgroundColor = .white
    }
}

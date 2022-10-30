import UIKit
import WebKit

class WebViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()

        setupBackButton()
        setupWebView()
    }

    // MARK: View components
    private let webView = WKWebView()

    private let backButton: UIButton = {
        let button = UIButton()

        button.setImage(.asset(.backIcon), for: .normal)
        button.tintColor = .asset(.ypBlack)

        return button
    }()
}

// MARK: - WebView

extension WebViewViewController {
    private func setupWebView() {
        webView.navigationDelegate = self

        guard var components = URLComponents(string: .k(.authorizeURL)) else {
            fatalError("Can't construct URLComponents for authorizeURL")
        }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: .k(.accessKey)),
            URLQueryItem(name: "redirect_uri", value: .k(.redirectURI)),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: .k(.accessScope))
        ]

        guard let url = components.url else {
            fatalError("Can't construct authorization URL")
        }

        let request = URLRequest(url: url)

        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
//    func webView(
//        _ webView: WKWebView,
//        decidePolicyFor navigationAction: WKNavigationAction,
//        decisionHandler: @escaping (WKNavigationActionPolicy
//        ) -> Void) {
//        //
//    }
}

// MARK: - Styling

extension WebViewViewController {
    private func setupView() {
        view.backgroundColor = .asset(.ypWhite)
    }
}

// MARK: - Layout

extension WebViewViewController {
    private func layoutComponents() {
        layoutWebView()
        layoutBackButton()
    }

    private func layoutWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }

    private func layoutBackButton() {
        backButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: safeArea.topAnchor, constant: 15),
            backButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor, constant: 16)
        ])
    }
}

// MARK: - Actions

extension WebViewViewController {
    private func setupBackButton() {
        backButton.addTarget(
            self, action: #selector(backPressed), for: .touchUpInside)
    }

    @objc private func backPressed() {
        dismiss(animated: true)
    }
}

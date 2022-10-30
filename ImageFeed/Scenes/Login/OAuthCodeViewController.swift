import UIKit
import WebKit

class OAuthCodeViewController: UIViewController {

    var delegate: OAuthCodeViewControllerDelegate?

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

extension OAuthCodeViewController {
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

        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension OAuthCodeViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy
        ) -> Void) {
        if let code = getCode(from: navigationAction) {
            delegate?.oauthCodeViewController(
                self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func getCode(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == .k(.authCodePath),
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else { return nil }

        return code
    }
}

// MARK: - Styling

extension OAuthCodeViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }

    private func setupView() {
        view.backgroundColor = .asset(.ypWhite)
    }
}

// MARK: - Layout

extension OAuthCodeViewController {
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

extension OAuthCodeViewController {
    private func setupBackButton() {
        backButton.addTarget(
            self, action: #selector(backPressed), for: .touchUpInside)
    }

    @objc private func backPressed() {
        delegate?.oauthCodeViewControllerDidCancel(self)
    }
}

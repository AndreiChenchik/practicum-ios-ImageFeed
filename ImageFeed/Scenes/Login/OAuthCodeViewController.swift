import UIKit
import WebKit

final class OAuthCodeViewController: UIViewController {

    var delegate: OAuthCodeViewControllerDelegate?
    var observations: [NSKeyValueObservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()

        setupBackButton()
        setupWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObservingProgress()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopObservingProgress()
    }

    // MARK: View components
    private let webView = WKWebView()

    private lazy var barBackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
           image: .asset(.backIcon).withTintColor(.asset(.ypBlack)),
           style: .plain,
           target: self,
           action: #selector(backPressed))

        button.tintColor = .asset(.ypBlack)

        return button
    }()

    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)

        progressView.tintColor = .asset(.ypBlack)

        return progressView
    }()
}

// MARK: - Observe Progress

extension OAuthCodeViewController {
    private func startObservingProgress() {
        observations.append(
            webView.observe(\.estimatedProgress) { [weak self] _, _ in
                self?.updateProgress()
            }
        )
    }

    private func stopObservingProgress() {
        observations = []
    }
}

// MARK: - WebView

extension OAuthCodeViewController {
    private func setupWebView() {
        webView.navigationDelegate = self

        guard var components = URLComponents(string: .key(.authorizeURL)) else {
            fatalError("Can't construct URLComponents for authorizeURL")
        }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: .key(.accessKey)),
            URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: .key(.accessScope))
        ]

        guard let url = components.url else {
            fatalError("Can't construct authorization URL")
        }

        let request = URLRequest(url: url)

        webView.load(request)
    }

    private func updateProgress() {
        progressView.setProgress(
            Float(webView.estimatedProgress),
            animated: true)

        if !progressView.isHidden && webView.estimatedProgress >= 0.999 {
            UIView.animate(withDuration: 0.4) {
                self.progressView.alpha = 0
            }
        }

        if progressView.isHidden && webView.estimatedProgress < 0.999 {
            UIView.animate(withDuration: 0.4) {
                self.progressView.alpha = 1
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension OAuthCodeViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
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
            urlComponents.path == .key(.authCodePath),
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
        layoutProgressView()
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

    private func layoutProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(progressView)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(
                equalTo: safeArea.topAnchor),
            progressView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Actions

extension OAuthCodeViewController {
    private func setupBackButton() {
        navigationItem.leftBarButtonItem = barBackButton
    }

    @objc private func backPressed() {
        delegate?.oauthCodeViewControllerDidCancel(self)
    }
}

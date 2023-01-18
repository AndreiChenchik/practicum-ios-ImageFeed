import UIKit
import WebKit

protocol OAuthCodeViewControllerProtocol: AnyObject {
    var presenter: OAuthCodeViewPresenterProtocol { get set }

    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol OAuthCodeViewControllerDelegate: AnyObject {
    func oauthCodeViewController(
        _ oauthCodeVC: OAuthCodeViewController,
        didAuthenticateWithCode code: String)

    func oauthCodeViewControllerDidCancel(
        _ oauthCodeVC: OAuthCodeViewController)
}

final class OAuthCodeViewController: UIViewController, OAuthCodeViewControllerProtocol {
    weak var delegate: OAuthCodeViewControllerDelegate?
    private var observations: [NSKeyValueObservation] = []

    init(
        presenter: OAuthCodeViewPresenterProtocol,
        delegate: OAuthCodeViewControllerDelegate? = nil
    ) {
        self.delegate = delegate
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    // MARK: OAuthCodeViewControllerProtocol

    var presenter: OAuthCodeViewPresenterProtocol

    func load(request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
    }

    func setProgressHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.4) {
            self.progressView.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: - Lifecycle

extension OAuthCodeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        layoutComponents()
        setupBackButton()

        webView.navigationDelegate = self
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObservingProgress()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopObservingProgress()
    }
}

// MARK: - Observe Progress

private extension OAuthCodeViewController {
    func startObservingProgress() {
        observations.append(
            webView.observe(\.estimatedProgress) { [weak self] _, _ in
                guard let self else { return }
                self.presenter.didUpdateProgressValue(self.webView.estimatedProgress)
            }
        )
    }

    func stopObservingProgress() {
        observations = []
    }
}

// MARK: - WKNavigationDelegate

extension OAuthCodeViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if
            let url = navigationAction.request.url,
            let code = presenter.getAuthCode(from: url)
        {
            delegate?.oauthCodeViewController(
                self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
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

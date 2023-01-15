import Foundation

public protocol OAuthCodePresenterProtocol {
    var view: OAuthCodeViewControllerProtocol? { get set }

    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func getAuthCode(from url: URL) -> String?
}

final class OAuthCodePresenter: OAuthCodePresenterProtocol {
    weak var view: OAuthCodeViewControllerProtocol?

    func viewDidLoad() {
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

        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        guard let view else { return }

        let newProgressValue = Float(newValue)
        view.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view.setProgressHidden(shouldHideProgress)
    }

    func getAuthCode(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == .key(.authCodePath),
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else { return nil }

        return code
    }
}

private extension OAuthCodePresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

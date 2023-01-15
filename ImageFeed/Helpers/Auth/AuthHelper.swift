import Foundation

protocol AuthHelperProtocol {
    var authRequest: URLRequest { get }
    func getAuthCode(from url: URL) -> String?
}

struct AuthHelper {
    let configuration: AuthConfiguration

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}

extension AuthHelper: AuthHelperProtocol {
    var authURL: URL {
        guard var components = URLComponents(string: configuration.authURLString) else {
            fatalError("Can't construct URLComponents for authorization URL")
        }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]

        guard let url = components.url else {
            fatalError("Can't construct authorization URL from URLComponents")
        }

        return url
    }

    var authRequest: URLRequest {
        .init(url: authURL)
    }

    func getAuthCode(from url: URL) -> String? {
        guard
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == configuration.authCodePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }),
            let code = codeItem.value
        else { return nil }

        return code
    }
}

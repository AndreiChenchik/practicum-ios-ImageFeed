import Foundation

protocol OAuth2TokenExtractor {
    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: OAuth2TokenExtractor {
    private let networkClient: NetworkRouting

    private var task: URLSessionTask?
    private var lastAuthCode: String?

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }

    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard lastAuthCode != authCode else { return }

        if let task, lastAuthCode == authCode {
            task.cancel()
        }

        guard var components = URLComponents(
            url: .unsplashAuthTokenURL,
            resolvingAgainstBaseURL: false)
        else { fatalError("Something went terribly wrong!") }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: .key(.accessKey)),
            URLQueryItem(name: "client_secret", value: .key(.secretKey)),
            URLQueryItem(name: "redirect_uri", value: .key(.redirectURI)),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        let query = components.url!.query!

        var request = URLRequest(url: .unsplashAuthTokenURL)
        request.httpMethod = "POST"
        request.httpBody = Data(query.utf8)

        lastAuthCode = authCode
        task = networkClient.fetch(request: request) { [weak self] result in
            defer { self?.task = nil }

            switch result {
            case .success(let data):
                do {
                    let oauthResponse = try JSONDecoder().decode(
                        OAuthTokenResponseBody.self, from: data
                    )

                    completion(.success(oauthResponse.accessToken))

                    self?.lastAuthCode = nil
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

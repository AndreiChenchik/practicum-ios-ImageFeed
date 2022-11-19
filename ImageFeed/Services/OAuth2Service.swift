import Foundation

protocol OAuth2TokenExtractor {
    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
}

final class OAuth2Service: OAuth2TokenExtractor {
    private let objectService: ObjectLoading

    private var task: URLSessionTask?
    private var lastAuthCode: String?

    init(objectService: ObjectLoading) {
        self.objectService = objectService
    }

    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard lastAuthCode != authCode else { return }
        task?.cancel()

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
        task = objectService.fetch(
            request: request
        ) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            defer { self?.task = nil }

            switch result {
            case let .success(body):
                completion(.success(body.accessToken))
                self?.lastAuthCode = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

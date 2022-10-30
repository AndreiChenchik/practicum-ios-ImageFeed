import Foundation

protocol OAuth2TokenExtractor {
    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void)
}

struct OAuth2Service: OAuth2TokenExtractor {
    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }

    func fetchAuthToken(
        authCode: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard var components = URLComponents(
            url: .unsplashAuthTokenURL,
            resolvingAgainstBaseURL: false)
        else { fatalError("Something went terribly wrong!") }

        components.queryItems = [
            URLQueryItem(name: "client_id", value: .k(.accessKey)),
            URLQueryItem(name: "client_secret", value: .k(.secretKey)),
            URLQueryItem(name: "redirect_uri", value: .k(.redirectURI)),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        let query = components.url!.query!

        var request = URLRequest(url: .unsplashAuthTokenURL)
        request.httpMethod = "POST"
        request.httpBody = Data(query.utf8)

        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let oauthResponse = try JSONDecoder().decode(
                        OAuthTokenResponseBody.self, from: data
                    )

                    completion(.success(oauthResponse.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

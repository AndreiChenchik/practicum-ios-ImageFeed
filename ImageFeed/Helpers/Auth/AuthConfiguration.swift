import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let authCodePath: String
}

extension AuthConfiguration {
    static var standard: Self {
        .init(
            accessKey: .key(.accessKey),
            secretKey: .key(.secretKey),
            redirectURI: .key(.redirectURI),
            accessScope: .key(.accessScope),
            defaultBaseURL: .unsplashBaseURL,
            authURLString: .key(.authorizeURL),
            authCodePath: .key(.authCodePath)
        )
    }
}

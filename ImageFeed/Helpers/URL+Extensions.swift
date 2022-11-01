import Foundation

extension URL {
    static var unsplashBaseURL: Self { .init(string: .key(.defaultBaseURL))! }
    static var unsplashAuthTokenURL: Self { .init(string: .key(.authTokenURL))! }
}

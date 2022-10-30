import Foundation

extension URL {
    static var unsplashBaseURL: Self { .init(string: .k(.defaultBaseURL))! }
    static var unsplashAuthTokenURL: Self { .init(string: .k(.authTokenURL))! }
}

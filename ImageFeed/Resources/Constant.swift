import Foundation

enum Constant: String {
    case accessKey = "NBvaOiD3g10XPHUjIZoUAz90xu817tY3H_UrIt8g0oo"
    case secretKey = "aWUgnHoQZs9BAJ0hsUdfNPim2YfL236VZYy2u-NBYfY"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    case defaultBaseURL = "https://api.unsplash.com"
    case authorizeURL = "https://unsplash.com/oauth/authorize"
    case authCodePath = "/oauth/authorize/native"
    case authTokenURL = "https://unsplash.com/oauth/token"
    case tokenDefaultsKey = "bearerToken"
}

extension String {
    static func key(_ constant: Constant) -> Self { constant.rawValue }
}

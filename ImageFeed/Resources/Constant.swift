import Foundation

enum Constant: String {
    case accessKey = "z2VYT0g1D8R5nrW5l4nnxw5bpGhZmcLfVH5Q2QUqSSo"
    case secretKey = "Trirf9j27yJ5VZS1t8Z1KgeKBDSX4vsFpgAhTi0X2U4"
    case redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    case accessScope = "public+read_user+write_likes"
    case defaultBaseURL = "https://api.unsplash.com"
    case authorizeURL = "https://unsplash.com/oauth/authorize"
    case authCodePath = "/oauth/authorize/native"
    case authTokenURL = "https://unsplash.com/oauth/token"
    case tokenDefaultsKey = "bearerToken"

    case profileImageChanged = "ProfileImageProviderDidChange"
}

extension String {
    static func key(_ constant: Constant) -> Self { constant.rawValue }
}

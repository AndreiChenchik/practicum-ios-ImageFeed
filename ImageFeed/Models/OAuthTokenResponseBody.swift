import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: TokenType
    let scope: String
    let createdTime: Date

    enum TokenType: String, Codable {
        case bearer = "Bearer"
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdTime = "created_at"
    }
}

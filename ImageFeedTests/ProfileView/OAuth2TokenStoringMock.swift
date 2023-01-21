@testable import ImageFeed
import Foundation

final class OAuth2TokenStoringMock: OAuth2TokenStoring {
    var token: String?
}

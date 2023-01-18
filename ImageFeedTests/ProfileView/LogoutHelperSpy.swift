@testable import ImageFeed
import Foundation

final class LogoutHelperSpy: LogoutHelperProtocol {
    var isLogoutCalled = false

    func logout() {
        isLogoutCalled = true
    }
}

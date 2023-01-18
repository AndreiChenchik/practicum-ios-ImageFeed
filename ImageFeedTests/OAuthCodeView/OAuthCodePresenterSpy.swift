@testable import ImageFeed
import Foundation

final class OAuthCodePresenterSpy: OAuthCodeViewPresenterProtocol {
    var isViewDidLoadCalled = false
    var view: OAuthCodeViewControllerProtocol?

    func viewDidLoad() {
        isViewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {}
    func getAuthCode(from url: URL) -> String? { nil }
}

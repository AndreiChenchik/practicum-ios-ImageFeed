import ImageFeed
import Foundation

final class OAuthCodeViewControllerSpy: OAuthCodeViewControllerProtocol {
    var presenter: OAuthCodePresenterProtocol
    var isLoadCalled = false

    init(presenter: OAuthCodePresenterProtocol) {
        self.presenter = presenter
    }

    func load(request: URLRequest) {
        isLoadCalled = true
    }

    func setProgressValue(_ newValue: Float) {}
    func setProgressHidden(_ isHidden: Bool) {}
}

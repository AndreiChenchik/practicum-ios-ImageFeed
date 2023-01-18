import Foundation

protocol OAuthCodeViewPresenterProtocol {
    var view: OAuthCodeViewControllerProtocol? { get set }

    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func getAuthCode(from url: URL) -> String?
}

final class OAuthCodeViewPresenter: OAuthCodeViewPresenterProtocol {
    weak var view: OAuthCodeViewControllerProtocol?
    private var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        let request = authHelper.authRequest
        view?.load(request: request)
        didUpdateProgressValue(0)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        guard let view else { return }

        let newProgressValue = Float(newValue)
        view.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view.setProgressHidden(shouldHideProgress)
    }

    func getAuthCode(from url: URL) -> String? {
        authHelper.getAuthCode(from: url)
    }
}

extension OAuthCodeViewPresenter {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

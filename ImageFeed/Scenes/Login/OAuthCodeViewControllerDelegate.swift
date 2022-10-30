import Foundation

protocol OAuthCodeViewControllerDelegate: AnyObject {
    func oauthCodeViewController(
        _ oauthCodeVC: OAuthCodeViewController,
        didAuthenticateWithCode code: String)

    func oauthCodeViewControllerDidCancel(
        _ oauthCodeVC: OAuthCodeViewController)
}

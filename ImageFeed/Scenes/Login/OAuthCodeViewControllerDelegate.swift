//
//  OAuthCodeViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 30/10/22.
//

import Foundation

protocol OAuthCodeViewControllerDelegate: AnyObject {
    func oauthCodeViewController(
        _ oauthCodeVC: OAuthCodeViewController,
        didAuthenticateWithCode code: String)

    func oauthCodeViewControllerDidCancel(
        _ oauthCodeVC: OAuthCodeViewController)
}

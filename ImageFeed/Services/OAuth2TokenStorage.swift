//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 30/10/22.
//

import Foundation

protocol OAuth2TokenStoring {
    var token: String? { get set }
}

struct OAuth2TokenStorage: OAuth2TokenStoring {
    let userDefaults: UserDefaults

    var token: String? {
        get {
            userDefaults.string(forKey: .k(.tokenDefaultsKey))
        }

        set {
            userDefaults.set(newValue, forKey: .k(.tokenDefaultsKey))
        }
    }
}

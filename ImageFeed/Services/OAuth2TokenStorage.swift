import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStoring {
    var token: String? { get set }
}

struct OAuth2TokenStorage: OAuth2TokenStoring {
    let keychainWrapper: KeychainWrapper

    var token: String? {
        get {
            keychainWrapper.string(forKey: .key(.tokenDefaultsKey))
        }

        set {
            if let newValue {
                keychainWrapper.set(newValue, forKey: .key(.tokenDefaultsKey))
            } else {
                keychainWrapper.removeObject(forKey: .key(.tokenDefaultsKey))
            }
        }
    }
}

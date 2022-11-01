import Foundation

protocol OAuth2TokenStoring {
    var token: String? { get set }
}

struct OAuth2TokenStorage: OAuth2TokenStoring {
    let userDefaults: UserDefaults

    var token: String? {
        get {
            userDefaults.string(forKey: .key(.tokenDefaultsKey))
        }

        set {
            userDefaults.set(newValue, forKey: .key(.tokenDefaultsKey))
        }
    }
}

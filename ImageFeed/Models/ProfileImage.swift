import Foundation

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?

    var best: String? { large ?? medium ?? small }
}

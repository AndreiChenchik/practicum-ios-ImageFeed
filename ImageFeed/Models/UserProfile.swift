import Foundation

struct UserProfile: Codable {
    let firstName: String?
    let lastName: String?

    let username: String?
    let twitterUsername: String?
    let instagramUsername: String?

    let profileImage: ProfileImage?

    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?

        var best: String? { large ?? medium ?? small }
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"

        case username
        case twitterUsername = "twitter_username"
        case instagramUsername = "instagram_username"

        case profileImage = "profile_image"
    }

    var fullName: String {
        [firstName, lastName]
            .compactMap({ $0 })
            .joined(separator: " ")
    }

    var handler: String {
        "@" + (twitterUsername ?? instagramUsername ?? username ?? "username")
    }

    var profilePictureURL: URL? {
        guard
            let profileImage,
            let urlString = profileImage.best,
            let url = URL(string: urlString)
        else { return nil }

        return url
    }
}

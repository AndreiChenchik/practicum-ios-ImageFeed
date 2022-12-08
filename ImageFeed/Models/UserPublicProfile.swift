import Foundation

struct UserPublicProfile: Codable {
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

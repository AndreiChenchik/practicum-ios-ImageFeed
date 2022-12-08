import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoURLs

    enum CodingKeys: String, CodingKey {
        case id, width, height, description, urls
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
    }

    struct PhotoURLs: Decodable {
        let regular: URL
        let thumb: URL
    }
}

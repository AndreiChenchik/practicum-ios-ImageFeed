import Foundation

struct Photo {
    let id: String
    let description: String?

    let thumbnailImage: URL
    let largeImage: URL
    let size: CGSize

    let createdAt: Date
    var isLiked: Bool
}

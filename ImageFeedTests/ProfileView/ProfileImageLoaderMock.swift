@testable import ImageFeed
import Foundation

final class ProfileImageLoaderMock: ProfileImageLoader {
    var avatarURLString: String? = "http://dummy.com"
    var didChangeNotification: Notification.Name = .init(rawValue: "dummyNotification")
    func fetchProfileImageURL(
        username: String,
        bearerToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {}

    func notify() {
        avatarURLString = "http://dummy2.com"
        NotificationCenter.default.post(
            name: didChangeNotification,
            object: self,
            userInfo: ["URL": avatarURLString as Any]
        )
    }
}

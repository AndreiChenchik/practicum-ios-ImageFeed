//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 19/11/22.
//

import Foundation

protocol ProfileImageLoader {
    var avatarURLString: String? { get }
    var didChangeNotification: Notification.Name { get }

    func fetchProfileImageURL(
        username: String,
        bearerToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
}

final class ProfileImageService {
    let didChangeNotification = Notification.Name(
        rawValue: "ProfileImageProviderDidChange"
    )

    private let notificationCenter: NotificationCenter
    private let objectLoader: ObjectLoading

    private (set) var avatarURLString: String? {
        didSet {
            notificationCenter.post(
                name: didChangeNotification,
                object: self,
                userInfo: ["URL": avatarURLString as Any]
            )
        }
    }

    init(
        notificationCenter: NotificationCenter,
        objectLoader: ObjectLoading
    ) {
        self.notificationCenter = notificationCenter
        self.objectLoader = objectLoader
        self.avatarURLString = nil
    }
}

extension ProfileImageService {
    enum LoadError: Error {
        case noProfileImage
    }
}

extension ProfileImageService: ProfileImageLoader {
    func fetchProfileImageURL(
        username: String,
        bearerToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        var url = URL.unsplashBaseURL
        url.appendPathComponent("/users/\(username)")

        objectLoader.fetch(
            url: url,
            bearerToken: bearerToken
        ) { [weak self] (result: Result<UserPublicProfile, Error>) in
            switch result {
            case let .failure(error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            case let .success(profile):
                if let avatarURLString = profile.profileImage?.best {
                    DispatchQueue.main.async {
                        completion(.success(avatarURLString))
                    }
                    self?.avatarURLString = avatarURLString
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(LoadError.noProfileImage))
                    }
                }
            }
        }
    }
}

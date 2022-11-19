//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 19/11/22.
//

import Foundation

protocol ProfileLoader {
    func fetchProfile(
        bearerToken: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    )
}

struct ProfileService {
    private let objectLoader: ObjectLoading

    init(objectLoader: ObjectLoading) {
        self.objectLoader = objectLoader
    }
}

extension ProfileService: ProfileLoader {
    func fetchProfile(
        bearerToken: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        var url = URL.unsplashBaseURL
        url.appendPathComponent("/me")

        objectLoader.fetch(
            url: url,
            bearerToken: bearerToken
        ) { (result: Result<UserProfile, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

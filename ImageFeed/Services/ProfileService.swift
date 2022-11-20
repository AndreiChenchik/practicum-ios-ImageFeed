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
    private let modelLoader: ModelLoading

    init(modelLoader: ModelLoading) {
        self.modelLoader = modelLoader
    }
}

extension ProfileService: ProfileLoader {
    func fetchProfile(
        bearerToken: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        var url = URL.unsplashBaseURL
        url.appendPathComponent("/me")

        modelLoader.fetch(
            url: url,
            bearerToken: bearerToken
        ) { (result: Result<UserProfile, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

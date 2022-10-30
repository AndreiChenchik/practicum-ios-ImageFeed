//
//  UserProfileService.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 30/10/22.
//

import Foundation

protocol UserProfileLoading {
    func fetchUserProfile(
        token: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void)
}

struct UserProfileService: UserProfileLoading {
    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }

    func fetchUserProfile(
        token: String,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        var url = URL.unsplashBaseURL
        url.appendPathComponent("/me")

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(token)", forHTTPHeaderField: "Authorization")

        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let userProfile = try JSONDecoder().decode(
                        UserProfile.self, from: data
                    )

                    completion(.success(userProfile))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  UserProfile.swift
//  ImageFeed
//
//  Created by Andrei Chenchik on 19/11/22.
//

import Foundation

struct UserPublicProfile: Codable {
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

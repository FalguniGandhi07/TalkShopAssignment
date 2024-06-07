//
//  ProfileData.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 08/06/24.
//

import Foundation

struct ProfileData: Codable {
    let status: String
    let data: UserData
}

struct UserData: Codable {
    let username: String
    let profilePictureUrl: String
    let posts: [Post]
}

struct Post: Codable, Identifiable {
    let id = UUID()
    let postId: String
    let videoUrl: String
    let thumbnailUrl: String
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case videoUrl
        case thumbnailUrl = "thumbnail_url"
        case likes
    }
}

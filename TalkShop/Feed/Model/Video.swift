//
//  Video.swift
//  TalkShop
//
//  Created by Falguni Gandhi on 04/06/24.
//

import Foundation
import SwiftUI
import AVKit

struct Video: Identifiable, Decodable {
    let id: String
    let videoUrl: String
    let thumbnailUrl: String
    let username: String
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case videoUrl
        case thumbnailUrl = "thumbnail_url"
        case username
        case likes
    }
}

struct FeedResponse: Decodable {
    let status: String
    let data: [Video]
}

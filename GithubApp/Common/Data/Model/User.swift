//
//  User.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

struct User: IDable, Codable {
    var id: Int
    var name: String
    var avatarUrl: String
    var userUrl: String
    var type: String
    var fullName: String?
    var location: String?
    var blog: String?
    var bio: String?
    var numberOfPublicRepos: Int?
    var followers: Int?
    var email: String?
    var registrationDate: String?
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case avatarUrl = "avatar_url"
        case userUrl = "html_url"
        case type = "type"
        case fullName = "name"
        case location = "location"
        case blog = "blog"
        case bio = "bio"
        case numberOfPublicRepos = "public_repos"
        case followers = "followers"
        case email = "email"
        case registrationDate = "created_at"
    }
}

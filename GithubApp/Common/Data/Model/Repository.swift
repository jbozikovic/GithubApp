//
//  Repository.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

struct Repository: IDable, Codable {
    var id: Int
    var name: String
    var fullName: String
    var desc: String?
    var owner: User
    var numberOfStars: Int
    var numberOfWatchers: Int
    var numberOfForks: Int
    var numberOfIssues: Int
    var language: String?
    var dateCreated: String
    var dateUpdated: String
    var repoUrl: String
    var homepage: String?
    var license: License?
    var topics: [String]
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case desc = "description"
        case owner = "owner"
        case numberOfStars = "stargazers_count"
        case numberOfWatchers = "watchers_count"
        case numberOfForks = "forks_count"
        case numberOfIssues = "open_issues_count"
        case language = "language"
        case dateCreated = "created_at"
        case dateUpdated = "updated_at"
        case repoUrl = "html_url"
        case homepage = "homepage"
        case license = "license"
        case topics = "topics"
    }
}

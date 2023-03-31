//
//  RepositoryResponse.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

struct RepositoryResponse: Codable {
    var repositories: [Repository]
    var totalCount: Int
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case repositories = "items"
        case totalCount = "total_count"
    }
}

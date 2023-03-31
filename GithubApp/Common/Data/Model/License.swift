//
//  License.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

struct License: Codable {
    var name: String
    var key: String
    var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case key = "key"
        case url = "url"
    }
}

//
//  DetailsCellViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

class DetailsCellViewModel {
    var caption: String
    var value: String
    
    init(caption: String, value: String) {
        self.caption = caption
        self.value = value
    }
}

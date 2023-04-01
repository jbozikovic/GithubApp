//
//  Configurable.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 01.04.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype T
    func configure(_ item: T)
}


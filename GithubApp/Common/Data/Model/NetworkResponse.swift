//
//  NetworkResponse.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

struct NetworkResponse<T> {
    let value: T
    let response: URLResponse
}

//
//  HTTPRequest.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}


//  MARK: - HTTPRequest
struct HTTPRequest: Requestable {
    var method: HTTPMethod
    @URLFormatter var url: String
    var params: [String : Any]?
    var headers: [HTTPHeader]?
}


//  MARK: - HTTPHeader
struct HTTPHeader {
    var value: String
    var headerField: String
}





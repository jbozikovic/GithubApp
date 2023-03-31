//
//  UsersAPIService.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

//  MARK: - UsersAPIProtocol
protocol UsersAPIProtocol {
    func getUser(username: String) -> AnyPublisher<User, Error>
}


//  MARK: - UsersAPIService
class UsersAPIService: NSObject, UsersAPIProtocol {
    let networkLayerService: NetworkLayerProtocol
    
    init(networkLayerService: NetworkLayerProtocol) {
        self.networkLayerService = networkLayerService
    }
    
    func getUser(username: String) -> AnyPublisher<User, Error> {
        let url = userDetailsUrl(username: username)
        let request: HTTPRequest = HTTPRequest(method: .get, url: url, params: nil, headers: nil)
        return networkLayerService.executeNetworkRequest(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}


//  MARK: - Url, header
private extension UsersAPIService {
    func userDetailsUrl(username: String) -> String {
        return "\(AppUrls.users)\(username)"
    }        
}

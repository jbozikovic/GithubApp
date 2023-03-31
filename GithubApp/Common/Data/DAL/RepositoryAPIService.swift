//
//  RepositoryAPIService.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RepositoryAPIProtocol
protocol RepositoryAPIProtocol {
    func searchRepositories(term: String, sort: String, itemsPerPage: Int, page: Int)  -> AnyPublisher<RepositoryResponse, Error>
}


//  MARK: - RepositoryAPIService
class RepositoryAPIService: NSObject, RepositoryAPIProtocol {
    let networkLayerService: NetworkLayerProtocol
    
    init(networkLayerService: NetworkLayerProtocol) {
        self.networkLayerService = networkLayerService
    }
            
    func searchRepositories(term: String, sort: String, itemsPerPage: Int, page: Int)  -> AnyPublisher<RepositoryResponse, Error> {
        let url = repositoriesUrl(term: term, sort: sort, itemsPerPage: itemsPerPage, page: page)
        let request: HTTPRequest = HTTPRequest(method: .get, url: url, params: nil, headers: nil)
        return networkLayerService.executeNetworkRequest(request: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}


//  MARK: - Url, header
private extension RepositoryAPIService {
    func repositoriesUrl(term: String, sort: String, itemsPerPage: Int, page: Int) -> String {
        return "\(AppUrls.repositories)?q=\(term)&sort=\(sort)&per_page=\(itemsPerPage)&page=\(page)"
    }    
}

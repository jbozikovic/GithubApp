//
//  RepositoryListRepository.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RepositoryListRepositoryProtocol
protocol RepositoryListRepositoryProtocol {
    func getRepositories(term: String, sort: String, page: Int) -> AnyPublisher<RepositoryResponse, Error>
}


//  MARK: - RepositoryListRepository
class RepositoryListRepository: NSObject, RepositoryListRepositoryProtocol {
    let apiService: RepositoryAPIProtocol
//    let dbService: RepositoryDBService

    init(apiService: RepositoryAPIProtocol) {
        self.apiService = apiService
    }
                
    func getRepositories(term: String, sort: String, page: Int) -> AnyPublisher<RepositoryResponse, Error> {
        guard Utility.hasInternetConnection else {
            return Fail(error: AppError.noInternet).eraseToAnyPublisher()
        }
        return getRepositoriesFromAPI(term: term, sort: sort, page: page)
    }
}


//  MARK: - Fetch data from API
private extension RepositoryListRepository {
    func getRepositoriesFromAPI(term: String, sort: String, page: Int) -> AnyPublisher<RepositoryResponse, Error> {
        return apiService.searchRepositories(term: term, sort: sort, itemsPerPage: Constants.numberOfItemsPerPage, page: page)
    }
}


//  MARK: - DB
private extension RepositoryListRepository {
    func getRepositoriesFromDB(term: String, sort: String, page: Int) -> [Repository]? {
        return nil
    }
}

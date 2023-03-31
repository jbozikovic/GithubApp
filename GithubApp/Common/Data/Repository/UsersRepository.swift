//
//  UsersRepository.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

//  MARK: - UsersRepositoryProtocol
protocol UsersRepositoryProtocol {
    func getUser(username: String) -> AnyPublisher<User, Error>
}


//  MARK: - UsersRepository
class UsersRepository: NSObject, UsersRepositoryProtocol {
    let apiService: UsersAPIProtocol
//    let dbService: UserDBService

    init(apiService: UsersAPIProtocol) {
        self.apiService = apiService
    }
    
    func getUser(username: String) -> AnyPublisher<User, Error> {
        guard Utility.hasInternetConnection else {
            return Fail(error: AppError.noInternet).eraseToAnyPublisher()
        }
        return getUserFromAPI(username: username)
    }
}


//  MARK: - Fetch data from API
private extension UsersRepository {
    func getUserFromAPI(username: String) -> AnyPublisher<User, Error> {
        return apiService.getUser(username: username)
    }
}


//  MARK: - Check is data downloaded
private extension UsersRepository {
    var shouldDownloadData: Bool {
        return true
    }
}


//  MARK: - DB
private extension UsersRepository {
    func getUserFromDB(username: String) -> User? {
        return nil
    }
}

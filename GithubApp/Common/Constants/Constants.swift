//
//  Constants.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import UIKit


//  MARK: - Constants
struct Constants {
    private init() {}
            
    static let networkTimeout: TimeInterval = 10     //  network timeout in seconds ...
    static let defaultNumberOfSections: Int = 1
    static let numberOfItemsPerPage: Int = 30
    static let dateFormat: String = "MMM dd, yyyy"
    static let dateFormatFull: String = "yyyy-MM-dd HH:mm:ss"
    static let zeroString = "0"
}


//  MARK: - App config
struct AppConfig {
    private init() {}
    
    static let githubAPIToken: String = "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"
}


//  MARK: - AppUI
struct AppUI {
    static let alphaHidden: CGFloat = 0.0
    static let alphaVisible: CGFloat = 1.0
    static let alphaTransparent: CGFloat = 0.5
    static let backgroundColor: UIColor = .white
    static let bodyFontColor: UIColor = .darkGray
    static let bodyFontSize: CGFloat = 15.0
    static let buttonColor: UIColor = .systemMint
    static let checkMarkIcon = "✔︎"
    static let cornerRadius: CGFloat = 4.0
    static let defaultFont = UIFont.systemFont(ofSize: 15.0)
    static let defaultBgColor: UIColor = .white
    static let navigationBarBGColor: UIColor = .white
    static let navigationBarTintColor: UIColor = .black
    static let navigationBarLargeTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let titleFont = UIFont.boldSystemFont(ofSize: 17.0)
    static let titleFontColor: UIColor = .black
}


//  MARK: - AppImages
enum AppImages: String {
    case sortIcon = "arrow.up.arrow.down"
    case noImage = "photo.fill"
    case watchers = "eye"
    case forks = "tuningfork"
    case issues = "ladybug"
    case star = "star"
    case followers = "person.fill"
    case repos = "desktopcomputer"
        
    var image: UIImage? {
        guard let systemImage = UIImage(systemName: self.rawValue) else {
            return UIImage(named: self.rawValue)
        }
        return systemImage
    }    
}


//  MARK: - AppStrings
enum AppStrings: String {
    case author = "author"
    case blog = "blog"
    case cancel = "cancel"
    case dateCreated = "date_created"
    case dateUpdated = "date_updated"
    case email = "email"
    case enterSearchTerm = "enter_search_term"
    case errorOccured = "error"
    case fetchDataFailed = "fetch_data_failed"
    case followers = "followers"
    case forks = "forks"
    case genericErrorMessage = "error_occurred_try_again"
    case issues = "issues"
    case language = "language"
    case license = "license"
    case location = "location"
    case noData = "no_data"
    case noInternet = "no_internet_connection"
    case notAvailable = "not_available"
    case ok = "ok"
    case registrationDate = "registration_date"
    case repositories = "repositories"
    case searchRepositories = "search_repositories"
    case sort = "sort"
    case sortDesc = "sort_desc"
    case stars = "stars"
    case topic = "topic"
    case userType = "user_type"
    case viewOnWeb = "view_on_web"
    case watchers = "watchers"
        
    var localized: String {
        return self.rawValue.localized()
    }
}


//  MARK: - AppUrls
struct AppUrls {
    private init() {}
    
    static let baseUrl                          = "https://api.github.com/"
    static let repositories                     = "search/repositories"
    static let users                            = "users/"
}


//  MARK: - AppKeys
enum AppKeys {}


//  MARK: - HTTPCode
enum HTTPCode: Int {
    case notAuthorized = 401
    case notFound = 404
    
    func message() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
    
    func title() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
}


//  MARK: - AppError
enum AppError: Error {
    case genericError
    case noData
    case noInternet
    case fetchDataError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return AppStrings.noData.rawValue
        case .noInternet:
            return AppStrings.noInternet.localized
        case .fetchDataError:
            return AppStrings.fetchDataFailed.localized
        default:
            return AppStrings.genericErrorMessage.localized
        }
    }
}


//  MARK: - Typealiases
typealias JSON = [String: Any]



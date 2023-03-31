//
//  RepositoryItemProtocol.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

protocol RepositoryItemProtocol {
    var repository: Repository { get }
    var title: String { get }
    var authorName: String { get }
    var authorTumbnailURL: URL? { get }
    var numberOfWatchersFormatted: String { get }
    var numberOfForksFormatted: String { get }
    var numberOfIssuesFormatted: String { get }
    var placeholderImage: UIImage? { get }
    var watchers: NSMutableAttributedString { get }
    var forks: NSMutableAttributedString { get }
    var issues: NSMutableAttributedString { get }
}


//  MARK: - Computed properties
extension RepositoryItemProtocol {
    var title: String {
        return repository.fullName
    }
    var authorName: String {
        return repository.owner.name
    }
    var authorTumbnailURL: URL? {
        return URL(string: repository.owner.avatarUrl)
    }
    var numberOfWatchersFormatted: String {
        return repository.numberOfWatchers.shortened()
    }
    var numberOfForksFormatted: String {
        return repository.numberOfForks.shortened()
    }
    var numberOfIssuesFormatted: String {
        return repository.numberOfIssues.shortened()
    }
    var placeholderImage: UIImage? {
        return AppImages.noImage.image
    }
    var author: NSMutableAttributedString {
        return "\(AppStrings.author.localized): \(authorName)".boldText(AppStrings.author.localized)
    }
    var watchers: NSMutableAttributedString {
        return "\(numberOfWatchersFormatted) \(AppStrings.watchers.localized)".boldText("\(numberOfWatchersFormatted)", fontSize: 15.0)
    }
    var forks: NSMutableAttributedString {
        return "\(numberOfForksFormatted) \(AppStrings.forks.localized)".boldText("\(numberOfForksFormatted)")
    }
    var issues: NSMutableAttributedString {
        return "\(numberOfIssuesFormatted) \(AppStrings.issues.localized)".boldText("\(numberOfIssuesFormatted)")
    }
    var watchersIcon: UIImage? {
        return AppImages.watchers.image
    }
    var forksIcon: UIImage? {
        return AppImages.forks.image
    }
    var issuesIcon: UIImage? {
        return AppImages.issues.image
    }
}

//
//  UserDetailsHeaderViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class UserDetailsHeaderViewModel {
    private var user: User
    
    init(user: User) {
        self.user = user
    }
}

//  MARK: - Computed properties (private)
private extension UserDetailsHeaderViewModel {
    var numberOfFollowersFromatted: String {
        guard let followers = user.followers else { return "0" }
        return followers.shortened()
    }
    var numberOfPublicReposFromatted: String {
        guard let numberOfPublicRepos = user.numberOfPublicRepos else { return "0" }
        return numberOfPublicRepos.shortened()
    }
}

//  MARK: - Computed properties
extension UserDetailsHeaderViewModel {
    var title: String {
        return user.fullName ?? user.name
    }
    var desc: String {
        return user.bio ?? ""
    }
    var avatarURL: URL? {
        return URL(string: user.avatarUrl)
    }
    var placeholderImage: UIImage? {
        return AppImages.noImage.image
    }
    var followers: NSMutableAttributedString {
        return "\(numberOfFollowersFromatted) \(AppStrings.followers.localized)".boldText("\(numberOfFollowersFromatted)")
    }
    var followersIcon: UIImage? {
        return AppImages.followers.image
    }
    var repositoriesIcon: UIImage? {
        return AppImages.repos.image
    }
    var publicRepos: NSMutableAttributedString {
        return "\(numberOfPublicReposFromatted) \(AppStrings.repositories.localized.lowercased())".boldText("\(numberOfPublicReposFromatted)")
    }
    var descLabeHeight: CGFloat {
        return desc.isEmpty ? 0.0 : 21.0
    }
}

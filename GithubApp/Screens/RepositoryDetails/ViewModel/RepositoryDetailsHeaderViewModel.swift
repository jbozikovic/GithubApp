//
//  RepositoryDetailsHeaderViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class RepositoryDetailsHeaderViewModel: RepositoryItemProtocol {
    var repository: Repository
    lazy var didTapAuthor = PassthroughSubject<Repository, Never>()
    
    init(repository: Repository) {
        self.repository = repository
    }
}

//  MARK: - Computed properties (private)
private extension RepositoryDetailsHeaderViewModel {
    var numberOfStarsFromatted: String {
        return repository.numberOfStars.shortened()
    }
}

//  MARK: - Computed properties
extension RepositoryDetailsHeaderViewModel {
    var desc: String {
        return repository.desc ?? ""
    }
    var url: String {
        return repository.repoUrl
    }
    var authorInfo: String {
        return repository.owner.userUrl
    }
    var stars: NSMutableAttributedString {
        return "\(numberOfStarsFromatted) \(AppStrings.stars.localized)".boldText("\(numberOfStarsFromatted)", fontSize: 15.0)
    }
    var starsIcon: UIImage? {
        return AppImages.star.image
    }
    var descLabeHeight: CGFloat {
        return desc.isEmpty ? 0.0 : 21.0
    }
    
    func userTappedAvatarImage() {
        didTapAuthor.send(repository)
    }
}

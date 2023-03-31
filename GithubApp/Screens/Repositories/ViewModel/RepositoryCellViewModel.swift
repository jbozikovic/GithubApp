//
//  RepositoryCellViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 23.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Combine

class RepositoryCellViewModel: RepositoryItemProtocol {
    var repository: Repository
    
    lazy var didTapAvatar = PassthroughSubject<Repository, Never>()
    
    init(repository: Repository) {
        self.repository = repository
    }
}


//  MARK: - Computed properties
extension RepositoryCellViewModel {
    var title: String {
        return repository.name
    }
    
    func userTappedAvatarImage() {
        didTapAvatar.send(repository)
    }
}

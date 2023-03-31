//
//  RepositoryDetailsViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - RepositoryDetailsSections
enum RepositoryDetailsSections: Int, CaseIterable {
    case dateCreated
    case dateUpdated
    case language
    case license
    case topic
                
    var title: String {
        switch self {
        case .dateCreated:
            return AppStrings.dateCreated.localized
        case .dateUpdated:
            return AppStrings.dateUpdated.localized
        case .language:
            return AppStrings.language.localized
        case .license:
            return AppStrings.license.localized
        case .topic:
            return AppStrings.topic.localized
        }
    }
}


//  MARK: - RepositoryDetailsViewModel
class RepositoryDetailsViewModel {
    private(set) var repositoryItem: Repository
    private(set) var haederViewModel: RepositoryDetailsHeaderViewModel
    private(set) var cellViewModels: [DetailsCellViewModel] = []
    private var cancellables = Set<AnyCancellable>()
            
    // MARK: - Publishers
    lazy var didTapAuthor = PassthroughSubject<String, Never>()
    lazy var shouldReloadData = PassthroughSubject<Void, Never>()
    lazy var didTapMoreInfo = PassthroughSubject<String, Never>()
                
    init(repositoryItem: Repository) {
        self.repositoryItem = repositoryItem
        haederViewModel = RepositoryDetailsHeaderViewModel(repository: repositoryItem)
        handleDidTapAuthorPublisher()
        loadData()
    }
    
    private func handleDidTapAuthorPublisher() {
        haederViewModel.didTapAuthor.sink { [weak self] (repo) in
            guard let weakSelf = self else { return }
            weakSelf.didTapAuthor.send(repo.owner.name)
        }.store(in: &cancellables)
    }
    
    //  MARK: - Load data
    private func loadData() {
        cellViewModels = [
            DetailsCellViewModel(caption: RepositoryDetailsSections.dateCreated.title, value: repositoryItem.dateCreated),
            DetailsCellViewModel(caption: RepositoryDetailsSections.dateUpdated.title, value: repositoryItem.dateUpdated),
            DetailsCellViewModel(caption: RepositoryDetailsSections.language.title, value: repositoryItem.language ?? AppStrings.notAvailable.localized),
            DetailsCellViewModel(caption: RepositoryDetailsSections.license.title, value: repositoryItem.license?.name ?? AppStrings.notAvailable.localized),
            DetailsCellViewModel(caption: RepositoryDetailsSections.topic.title, value: topics )
        ]
        shouldReloadData.send()
    }
}


//  MARK: - Number of items,views visibility...
extension RepositoryDetailsViewModel {
    private var topics: String {
        let topicsFlatted = repositoryItem.topics.compactMap { $0 }.joined(separator: ", ")
        return topicsFlatted.isEmpty ? AppStrings.notAvailable.localized : topicsFlatted
    }
    var title: String {
        return repositoryItem.name
    }
    var numberOfItems: Int {
        return cellViewModels.count
    }
    var numberOfSections: Int {
        return Constants.defaultNumberOfSections
    }
    var url: String {
        return repositoryItem.repoUrl
    }
        
    func getItemAtIndex(_ index: Int) -> DetailsCellViewModel? {
        //  TODO: add array extension
        guard !cellViewModels.isEmpty, index < cellViewModels.count else { return nil }
        return cellViewModels[index]
    }

    func userTappedMoreInfoButton() {
        didTapMoreInfo.send(url)
    }
}



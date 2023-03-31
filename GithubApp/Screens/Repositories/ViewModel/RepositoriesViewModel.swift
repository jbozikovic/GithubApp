//
//  RepositoriesViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

//  MARK: - RepositoriesSortAction
enum RepositoriesSortAction: String, CaseIterable {
    case stars = "stars"
    case forks = "forks"
    case updated = "updated"
            
    var title: String {
        switch self {
        case .stars:
            return AppStrings.stars.localized
        case .forks:
            return AppStrings.forks.localized
        case .updated:
            return AppStrings.dateUpdated.localized
        }
    }
}


//  MARK: - RepositoriesViewModel
class RepositoriesViewModel: Loadable {
    private(set) var repositories: [Repository] = []
    private(set) var viewModels: [RepositoryCellViewModel] = []
    private(set) var repository: RepositoryListRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var isFetchInProgress: Bool = false
    private var page: Int = 1
    private var totalCount: Int = 0
    private var sortOption: RepositoriesSortAction = .stars
    private var searchTerm: String = ""
        
    //  MARK: - Loadable
    var isLoading: Bool = false
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
            
    // MARK: - Publishers
    lazy var didTapRepo = PassthroughSubject<Repository, Never>()
    lazy var didTapUserAvatar = PassthroughSubject<String, Never>()
    lazy var failure = PassthroughSubject<Error, Never>()
    lazy var shouldReloadData = PassthroughSubject<[IndexPath]?, Never>()
    lazy var presentActionSheet = PassthroughSubject<(String, [RepositoriesSortAction]), Never>()
                    
    init(repository: RepositoryListRepositoryProtocol) {
        self.repository = repository
    }
    
    //  MARK - Fetch data
    func searchRepositories(term: String) {
        searchTerm = term
        resetAndLoadData()
    }
    
    private func resetAndLoadData() {
        resetData()
        loadData()
    }
    
    private func resetData() {
        totalCount = 0
        page = 1
        repositories = []
        viewModels = []
    }
    
    //  MARK: - Load data
    private func loadData() {
        guard !isFetchInProgress else { return }
        isFetchInProgress = true
        updateLoadingStatusIfNeeded()
        repository.getRepositories(term: searchTerm, sort: sortOption.rawValue, page: page)
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                weakSelf.updateLoadingStatusIfNeeded()
                switch completion {
                case .failure(let error):
                    weakSelf.failure.send(error)
                    weakSelf.isFetchInProgress = false
                case .finished:
                    Utility.printIfDebug(string: "Received completion: \(completion).")
                }
            }, receiveValue: { [weak self] response in
                guard let weakSelf = self else { return }
                weakSelf.updateLoadingStatusIfNeeded()
                weakSelf.prepareDataAndReload(response: response)
            }).store(in: &cancellables)
    }
    
    private func updateLoadingStatusIfNeeded() {
        guard page == 1 else { return }
        updateLoadingStatus()
    }
    
    //  MARK: - Prepare view models
    private func prepareDataAndReload(response: RepositoryResponse) {
        updateData(response: response)
        prepareViewModels(newRepos: response.repositories)
        if page == 1 {
            let indexPathsToReload = calculateIndexPathsToReload(from: response.repositories)
            DispatchQueue.main.async {
                self.shouldReloadData.send(indexPathsToReload)
            }
        } else {
            DispatchQueue.main.async {
                self.shouldReloadData.send(nil)
            }
        }
    }
    
    private func updateData(response: RepositoryResponse) {
        page += 1
        isFetchInProgress = false
        totalCount = response.totalCount
        repositories.append(contentsOf: response.repositories)
    }
    
    private func prepareViewModels(newRepos: [Repository]) {
        let newViewModels = newRepos.map { RepositoryCellViewModel(repository: $0) }
        newViewModels.forEach { vm in
            vm.didTapAvatar.sink { [weak self] (repo) in
                guard let weakSelf = self else { return }
                weakSelf.didTapUserAvatar.send(repo.owner.name)
            }.store(in: &cancellables)
        }
        viewModels.append(contentsOf: newViewModels)
    }
        
    func refreshData() {
        loadData()
    }
}


//  MARK: - Pagination (calculate index to reload)
private extension RepositoriesViewModel {
    /** Function calculates  index paths for the last page of tasks received from the API. Used to refresh only the content that's changed, instead of reloading the whole table view.
    @author Jurica Bozikovic
    */
    func calculateIndexPathsToReload(from newRepos: [Repository]) -> [IndexPath] {
        let startIndex = repositories.count - newRepos.count
        let endIndex = startIndex + newRepos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}


//  MARK: - Number of items,views visibility...
extension RepositoriesViewModel {
    var numberOfItems: Int {
        return totalCount
    }
    var currentCount: Int {
        return viewModels.count
    }
    var numberOfSections: Int {
        return Constants.defaultNumberOfSections
    }
    var hasData: Bool {
        currentCount > 0
    }
        
    func getItemAtIndex(_ index: Int) -> RepositoryCellViewModel? {
        guard !viewModels.isEmpty, index < viewModels.count else { return nil }
        return self.viewModels[index]
    }

    func userSelectedRow(index: Int) {
        guard let vm = getItemAtIndex(index) else { return }
        didTapRepo.send(vm.repository)
    }
}


//  MARK: - Sort
extension RepositoriesViewModel {
    var sortTitle: String {
        AppStrings.sort.localized
    }
    var sortMessage: String {
        AppStrings.sortDesc.localized
    }

    func sortActionTitle(_ action: RepositoriesSortAction) -> String {
        return action == sortOption ? "\(AppUI.checkMarkIcon) \(action.title)" : action.title
    }
    
    func handleSortActions(action: RepositoriesSortAction) {
        sortOption = action
        resetAndLoadData()
    }
}

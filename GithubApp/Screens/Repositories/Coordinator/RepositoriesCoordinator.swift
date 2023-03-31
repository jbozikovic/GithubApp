//
//  RepositoriesCoordinator.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class RepositoriesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    var viewModel: RepositoriesViewModel?
    var repository: RepositoryListRepository
    private var cancellables = Set<AnyCancellable>()
    
    private let networkLayerService: NetworkLayerProtocol = NetworkLayerService()
        
    init(presenter: UINavigationController) {
        self.presenter = presenter
        childCoordinators = []
        let apiService = RepositoryAPIService(networkLayerService: networkLayerService)
        repository = RepositoryListRepository(apiService: apiService)
    }
    
    func start() {
        setupViewModel()
        navigateToRepositoriesViewController()
    }
}


//  MARK: - View model
private extension RepositoriesCoordinator {
    private func setupViewModel() {
        viewModel = RepositoriesViewModel(repository: repository)
        handleDidTapRepoPublisher()
        handleDidTapUserAvatarPublisher()
    }
    
    func handleDidTapRepoPublisher() {
        viewModel?.didTapRepo.sink { [weak self] (repo) in
            guard let weakSelf = self else { return }
            weakSelf.navigateToRepositoryDetails(repository: repo)
        }.store(in: &cancellables)
    }
    
    func handleDidTapUserAvatarPublisher() {
        viewModel?.didTapUserAvatar.sink { [weak self] (username) in
            guard let weakSelf = self else { return }
            weakSelf.navigateToUserDetails(username: username)
        }.store(in: &cancellables)
    }
}


//  MARK: - Repository list
private extension RepositoriesCoordinator {
    private func navigateToRepositoriesViewController() {
        guard let vm = viewModel else { return }
        let vc = RepositoriesViewController(viewModel: vm)
        presenter.pushViewController(vc, animated: true)
    }
}


//  MARK: - Repository details
private extension RepositoriesCoordinator {
    func navigateToRepositoryDetails(repository: Repository) {
        let vc = RepositoryDetailsViewController(viewModel: repoDetailsViewModel(repositoryItem: repository))
        presenter.pushViewController(vc, animated: true)
    }
    
    func repoDetailsViewModel(repositoryItem: Repository) -> RepositoryDetailsViewModel {
        let viewModel = RepositoryDetailsViewModel(repositoryItem: repositoryItem)
        viewModel.didTapAuthor.sink { [weak self] (username) in
            guard let weakSelf = self else { return }
            weakSelf.navigateToUserDetails(username: username)
        }.store(in: &cancellables)
        viewModel.didTapMoreInfo.sink { [weak self] url in
            guard let weakSelf = self else { return }
            weakSelf.openURLInBrowser(urlString: url)
        }.store(in: &cancellables)
        return viewModel
    }
}


//  MARK: - User details
private extension RepositoriesCoordinator {
    var userDetailsRepository: UsersRepositoryProtocol {
        return UsersRepository(apiService: userDetailsAPIService)
    }
    var userDetailsAPIService: UsersAPIProtocol {
        return UsersAPIService(networkLayerService: networkLayerService)
    }
    
    func navigateToUserDetails(username: String) {
        let viewModel = UserDetailsViewModel(repository: userDetailsRepository, username: username)
        viewModel.didTapMoreInfo.sink { [weak self] url in
            guard let weakSelf = self else { return }
            weakSelf.openURLInBrowser(urlString: url)
        }.store(in: &cancellables)
        let vc = UserDetailsViewController(viewModel: viewModel)
        presenter.pushViewController(vc, animated: true)
    }
}


//  MARK: - HandleURLProtocol (open URL in browser)
extension RepositoriesCoordinator: HandleURLProtocol {
    func openURLInBrowser(urlString: String) {
        openURLInExternalBrowser(urlString: urlString)
    }
}

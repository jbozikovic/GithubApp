//
//  UserDetailsViewModel.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

//  MARK: - UserDetailsSection
enum UserDetailsSection: Int, CaseIterable {
    case type
    case location
    case blog
    case email
    case registrationDate
                
    var title: String {
        switch self {
        case .type:
            return AppStrings.userType.localized
        case .location:
            return AppStrings.location.localized
        case .blog:
            return AppStrings.blog.localized
        case .email:
            return AppStrings.email.localized
        case .registrationDate:
            return AppStrings.registrationDate.localized
        }
    }
}


//  MARK: - UserDetailsViewModel
class UserDetailsViewModel: Loadable {
    private(set) var repository: UsersRepositoryProtocol
    private(set) var haederViewModel: UserDetailsHeaderViewModel?
    private(set) var cellViewModels: [DetailsCellViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    private var username: String
    private(set) var user: User? = nil {
        didSet {
            prepareDataAndReload()
        }
    }
    
    //  MARK: - Loadable
    var isLoading: Bool = false
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    // MARK: - Publishers
    lazy var failure = PassthroughSubject<Error, Never>()
    lazy var shouldReloadData = PassthroughSubject<Void, Never>()
    lazy var didTapMoreInfo = PassthroughSubject<String, Never>()
    
    init(repository: UsersRepositoryProtocol, username: String) {
        self.repository = repository
        self.username = username
        loadData()
    }
    
    //  MARK: - Load data
    private func loadData() {
        updateLoadingStatus()
        repository.getUser(username: username).sink(receiveCompletion: { [weak self] completion in
            guard let weakSelf = self else { return }
            weakSelf.updateLoadingStatus()
            switch completion {
            case .failure(let error):
                weakSelf.failure.send(error)
            case .finished:
                Utility.printIfDebug(string: "Received completion: \(completion).")
            }
        }, receiveValue: { [weak self] user in
            guard let weakSelf = self else { return }
            weakSelf.user = user
            weakSelf.haederViewModel = UserDetailsHeaderViewModel(user: user)
        }).store(in: &cancellables)
    }
        
    private func prepareDataAndReload() {
        cellViewModels = [
            DetailsCellViewModel(caption: UserDetailsSection.type.title, value: type),
            DetailsCellViewModel(caption: UserDetailsSection.location.title, value: location),
            DetailsCellViewModel(caption: UserDetailsSection.blog.title, value: blog),
            DetailsCellViewModel(caption: UserDetailsSection.email.title, value: email),
            DetailsCellViewModel(caption: UserDetailsSection.registrationDate.title, value: registrationDate)
        ]
        shouldReloadData.send()
    }
}


//  MARK: - Number of items,views visibility...
extension UserDetailsViewModel {
    var type: String {
        return user?.type ?? AppStrings.notAvailable.localized
    }
    var location: String {
        return user?.location ?? AppStrings.notAvailable.localized
    }
    var blog: String {
        return user?.blog ?? AppStrings.notAvailable.localized
    }
    var email: String {
        return user?.email ?? AppStrings.notAvailable.localized
    }
    var registrationDate: String {
        return user?.registrationDate ?? AppStrings.notAvailable.localized
    }
    var title: String {
        return user?.name ?? ""
    }
    var numberOfItems: Int {
        return cellViewModels.count
    }
    var numberOfSections: Int {
        return Constants.defaultNumberOfSections
    }
    var url: String {
        return user?.userUrl ?? ""
    }
    var avatarURL: URL? {
        guard let url = user?.avatarUrl else { return nil }
        return URL(string: url)
    }
    var placeholderImage: UIImage? {
        return AppImages.noImage.image
    }
        
    func getItemAtIndex(_ index: Int) -> DetailsCellViewModel? {        
        guard !cellViewModels.isEmpty, index < cellViewModels.count else { return nil }
        return cellViewModels[index]
    }

    func userTappedMoreInfoButton() {
        didTapMoreInfo.send(url)
    }
}



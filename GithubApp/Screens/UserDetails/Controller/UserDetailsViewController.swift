//
//  UserDetailsViewController.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine
import SnapKit


// MARK: - UserDetailsHeaderViewConstants
private struct UserDetailsConstants {
    private init() {}
    
    static let footerViewHeight: CGFloat = 72.0
    static let buttonHeight: CGFloat = 48.0
    static let leadingTrailingOffset: CGFloat = 30.0
}

class UserDetailsViewController: UIViewController, ErrorHandlerProtocol, ViewStyleable, ActivityIndicatorPresentable {
    lazy var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    lazy var footerView: UIView = UIView(frame: .zero)
    lazy var moreInfoButton: UIButton = UIButton(frame: .zero)
        
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: UserDetailsViewModel
    var dataSource: UserDetailsDataSource? {
        didSet {
            setTableViewDataSourceAndReload()
        }
    }

    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupGUI()
        setupViewModel()
        loadData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    //  MARK: - Setup GUI
    func setupGUI() {
        title = viewModel.title
        footerView.backgroundColor = AppUI.backgroundColor
        setupNavigationBar()
        setupNavigationBarItems()
        setupBackground()
        addSubviews()
        setupConstraints()
        setupMoreInfoButton()
        setupTableView()
        showActivityIndicator()
    }
    
    private func addSubviews() {
        footerView.addSubview(moreInfoButton)
        [tableView, footerView].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupMoreInfoButton() {
        moreInfoButton.layer.cornerRadius = AppUI.cornerRadius
        moreInfoButton.backgroundColor = AppUI.buttonColor
        moreInfoButton.setTitle(AppStrings.viewOnWeb.localized, for: .normal)
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTap), for: .touchUpInside)
    }

    //  MARK: - Table view (list)
    private func setupTableView() {
        tableView.backgroundColor = AppUI.backgroundColor
        tableView.delegate = self
        setupTableViewCell()
        setupTableViewHeader()
        tableView.isHidden = true
    }

    private func setupTableViewCell() {
        tableView.register(UINib(nibName: String(describing: DetailsCell.self), bundle: nil), forCellReuseIdentifier: DetailsCell.reuseIdentifier)
        tableView.estimatedRowHeight = DetailsCell.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func setupTableViewHeader() {
        tableView.register(UserDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: UserDetailsHeaderView.reuseIdentifier)
        tableView.estimatedSectionHeaderHeight = UserDetailsHeaderView.estimatedHeight
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
        
    private func setTableViewDataSourceAndReload() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    private func loadData() {
        self.dataSource = UserDetailsDataSource(viewModel: viewModel)
    }

    @objc func moreInfoButtonTap() {
        viewModel.userTappedMoreInfoButton()
    }
}


//  MARK: - Constraints
private extension UserDetailsViewController {
    func setupConstraints() {
        setupTableViewConstraints()
        setupFooterViewConstraints()
        setupMoreInfoButtonConstraints()
    }
    
    func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
    }
    
    func setupFooterViewConstraints() {
        footerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UserDetailsConstants.footerViewHeight)
        }
    }
    
    func setupMoreInfoButtonConstraints() {
        moreInfoButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(UserDetailsConstants.leadingTrailingOffset)
            make.trailing.equalToSuperview().offset(-UserDetailsConstants.leadingTrailingOffset)
            make.height.equalTo(UserDetailsConstants.buttonHeight)
        }
    }
}


//  MARK: - Navigation
extension UserDetailsViewController: NavigationBarProtocol {
}


//  MARK: - View model, callbacks
private extension UserDetailsViewController {
    func setupViewModel() {
        handleLoadingStatusUpdated()
        handleFailurePublisher()
        handleShouldReloadDataPublisher()
    }

    func handleFailurePublisher() {
        viewModel.failure.sink { [weak self] (error) in
            guard let weakSelf = self else { return }            
            weakSelf.handleError(error)
        }.store(in: &cancellables)
    }

    private func handleShouldReloadDataPublisher() {
        viewModel.shouldReloadData.sink { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.title = weakSelf.viewModel.title
            weakSelf.tableView.reloadData()
            weakSelf.tableView.isHidden = false
        }.store(in: &cancellables)
    }

    func handleLoadingStatusUpdated() {
        viewModel.loadingStatusUpdated.sink { [weak self] (isLoading) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.isHidden = isLoading
                isLoading ? weakSelf.showActivityIndicator() : weakSelf.hideActivityIndicator()
            }
        }.store(in: &cancellables)
    }
}

//  MARK: - UITableViewDelegate
extension UserDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UserDetailsHeaderView.reuseIdentifier) as? UserDetailsHeaderView else { return nil }
        if let vm = viewModel.haederViewModel {
            headerView.setupView(viewModel: vm)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UserDetailsHeaderView.estimatedHeight
    }
}




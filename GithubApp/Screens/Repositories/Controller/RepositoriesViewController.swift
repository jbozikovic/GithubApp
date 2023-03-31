//
//  RepositoriesViewController.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class RepositoriesViewController: UIViewController, ErrorHandlerProtocol, ViewStyleable, ActivityIndicatorPresentable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RepositoriesViewModel
    var dataSource: RepositoriesDataSource? {
        didSet {
            setTableViewDataSourceAndReload()
        }
    }
    
    init(viewModel: RepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RepositoriesViewController.self), bundle: nil)
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
        title = AppStrings.repositories.localized
        setupNavigationBar()
        setupNavigationBarItems()
        setupBackground()
        handleViewVisibility(hasData: false, text: AppStrings.enterSearchTerm.localized)
        setupSearchBar()
        setupTableView()
    }
    
    private func handleViewVisibility(hasData: Bool, text: String) {
        infoLabel.isHidden = hasData
        tableView.isHidden = !hasData
        infoLabel.text = text
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = AppStrings.searchRepositories.localized
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }
    
    //  MARK: - Table view (list)
    private func setupTableView() {
        tableView.backgroundColor = AppUI.backgroundColor
        setupTableViewCell()
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupTableViewCell() {
        tableView.register(UINib(nibName: String(describing: RepositoryCell.self), bundle: nil), forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        tableView.estimatedRowHeight = RepositoryCell.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
        
    private func setTableViewDataSourceAndReload() {
        tableView.dataSource = dataSource
        tableView.prefetchDataSource = dataSource
        tableView.reloadData()
    }
    
    private func loadData() {
        self.dataSource = RepositoriesDataSource(viewModel: viewModel)
    }
}


//  MARK: - NavigationBarProtocol
extension RepositoriesViewController: NavigationBarProtocol {
    func setupNavigationBarItems() {
        navigationItem.hidesBackButton = false
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = [Utility.createBarButtonItem(image: AppImages.sortIcon.image, target: self, action: #selector(barButtonItemTapped), identifier: "")]
    }
    
    @objc func barButtonItemTapped(sender: UIBarButtonItem) {
        presentActionSheet(title: viewModel.sortTitle, message: viewModel.sortMessage, actions: RepositoriesSortAction.allCases) { [weak self] action in
            guard let weakSelf = self, let action else { return }
            weakSelf.viewModel.handleSortActions(action: action)
            weakSelf.tableView.layoutIfNeeded()
            weakSelf.tableView.contentOffset = .zero
        }
    }
}


//  MARK: - Action sheet for sorting
private extension RepositoriesViewController {
    func presentActionSheet(title: String?, message: String?, actions: [RepositoriesSortAction], actionHandler: @escaping ((_ action: RepositoriesSortAction?) -> Void)) {
        let actionSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { (action) in
            let title = viewModel.sortActionTitle(action)
            let alertAction = UIAlertAction(title: title.capitalized, style: .default) { (alertAction) in
                actionHandler(action)
            }
            actionSheet.addAction(alertAction)
        }
        actionSheet.addAction(UIAlertAction(title: AppStrings.cancel.localized, style: .destructive, handler: nil))
        self.present(actionSheet, animated: true)
    }
}

    
//  MARK: - View model, callbacks
private extension RepositoriesViewController {
    func setupViewModel() {
        handleFailurePublisher()
        handleShouldReloadDataPublisher()
        handleLoadingStatusUpdated()
    }
    
    func handleFailurePublisher() {
        viewModel.failure.sink { [weak self] (error) in
            guard let weakSelf = self else { return }
            weakSelf.handleError(error)
        }.store(in: &cancellables)
    }
    
    private func handleShouldReloadDataPublisher() {
        viewModel.shouldReloadData.sink { [weak self] (newIndexPathsToReload) in
            guard let weakSelf = self else { return }
            weakSelf.handleViewVisibility(hasData: weakSelf.viewModel.hasData, text: weakSelf.viewModel.hasData ? "" : AppStrings.noData.localized)
            //  newIndexPathsToReload are nil ... 1st page or 1st batch of data - reload table view
            guard let indexPaths = newIndexPathsToReload else {
                weakSelf.tableView.reloadData()
                return
            }
            //  find the visible cells that needs reloading and tell the table view to reload only those
            DispatchQueue.main.async {
                let indexPathsToReload = weakSelf.visibleIndexPathsToReload(intersecting: indexPaths)
                weakSelf.tableView.reloadRows(at: indexPathsToReload, with: .fade)
            }
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
        
    /** Function calculates the cells of the table view that needs to be reloaded when we receive new data. It calculates the intersection of the IndexPaths passed in (previously calculated by the view model) with the visible ones. Used  to avoid refreshing cells that are not currently visible on the screen.
    @author Jurica Bozikovic
    */
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = self.tableView?.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}


// MARK: - UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let term = searchBar.text, !term.isEmpty else { return }
        tableView?.isHidden = true
        tableView.layoutIfNeeded()
        tableView.contentOffset = .zero
        viewModel.searchRepositories(term: term)
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}


//  MARK: - UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.userSelectedRow(index: indexPath.row)
    }
}

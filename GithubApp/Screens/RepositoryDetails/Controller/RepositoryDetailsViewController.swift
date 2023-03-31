//
//  RepositoryDetailsViewController.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 23.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class RepositoryDetailsViewController: UIViewController, ViewStyleable, NavigationBarProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var moreInfoButton: UIButton!
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: RepositoryDetailsViewModel
    var dataSource: RepositoryDetailsDataSource? {
        didSet {
            setTableViewDataSourceAndReload()
        }
    }
    
    init(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RepositoryDetailsViewController.self), bundle: nil)
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
        setupNavigationBar()
        setupNavigationBarItems()
        setupBackground()
        setupMoreInfoButton()
        setupTableView()
    }
    
    private func setupMoreInfoButton() {
        moreInfoButton.layer.cornerRadius = AppUI.cornerRadius
        moreInfoButton.setTitle(AppStrings.viewOnWeb.localized, for: .normal)
    }
    
    //  MARK: - Table view (list)
    private func setupTableView() {
        tableView?.backgroundColor = AppUI.backgroundColor
        tableView?.delegate = self
        setupTableViewCell()
        setupTableViewHeader()
    }
    
    private func setupTableViewCell() {
        tableView?.register(UINib(nibName: String(describing: DetailsCell.self), bundle: nil), forCellReuseIdentifier: DetailsCell.reuseIdentifier)
        tableView?.estimatedRowHeight = DetailsCell.estimatedHeight
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTableViewHeader() {
        tableView?.register(UINib(nibName: String(describing: RepositoryDetailsHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: RepositoryDetailsHeaderView.reuseIdentifier)
        tableView?.estimatedSectionHeaderHeight = RepositoryDetailsHeaderView.estimatedHeight
        tableView?.sectionHeaderHeight = UITableView.automaticDimension
    }
        
    private func setTableViewDataSourceAndReload() {
        tableView?.dataSource = dataSource
        tableView?.reloadData()
    }
    
    private func loadData() {
        self.dataSource = RepositoryDetailsDataSource(viewModel: viewModel)        
    }
    
    @IBAction func moreInfoButtonTap(_ sender: UIButton) {
        viewModel.userTappedMoreInfoButton()
    }
}

    
//  MARK: - View model, callbacks
private extension RepositoryDetailsViewController {
    func setupViewModel() {
        handleShouldReloadDataPublisher()
    }
    
    private func handleShouldReloadDataPublisher() {
        viewModel.shouldReloadData.sink { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView?.reloadData()
        }.store(in: &cancellables)
    }
}


//  MARK: - UITableViewDelegate
extension RepositoryDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RepositoryDetailsHeaderView.reuseIdentifier) as? RepositoryDetailsHeaderView else { return nil }
        headerView.setupView(viewModel: viewModel.haederViewModel)        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension // viewModel.headerHeight(section: section)
    }
}




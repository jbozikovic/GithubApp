//
//  RepositoriesDataSource.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class RepositoriesDataSource: NSObject {
    private let viewModel: RepositoriesViewModel

    init(viewModel: RepositoriesViewModel) {
        self.viewModel = viewModel
    }
}


// MARK: - UITableViewDataSource
extension RepositoriesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier, for: indexPath) as! RepositoryCell
        if let item: RepositoryCellViewModel = viewModel.getItemAtIndex(indexPath.row) {
            cell.setupCell(viewModel: item)
        }
        return cell
    }
                
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
}


//  MARK: - UITableViewDataSourcePrefetching
extension RepositoriesDataSource: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        Utility.printIfDebug(string: "prefetching row of \(indexPaths)")
        if indexPaths.contains(where: isLoadingCell) {
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
}


//  MARK: - Is loading cell, refresh data
private extension RepositoriesDataSource {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    private func reloadData() {
        viewModel.refreshData()
    }
}




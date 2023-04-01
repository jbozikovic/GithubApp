//
//  RepositoryDetailsDataSource.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class RepositoryDetailsDataSource: NSObject {
    private let viewModel: RepositoryDetailsViewModel

    init(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension RepositoryDetailsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.reuseIdentifier, for: indexPath) as! DetailsCell
        if let item: DetailsCellViewModel = viewModel.getItemAtIndex(indexPath.row) {
            cell.configure(item)
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

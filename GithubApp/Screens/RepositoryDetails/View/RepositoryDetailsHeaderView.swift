//
//  RepositoryDetailsHeaderView.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class RepositoryDetailsHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var starsView: ImageWithLabelView!
    @IBOutlet weak var forksView: ImageWithLabelView!
    @IBOutlet weak var watchersView: ImageWithLabelView!
    @IBOutlet weak var issuesView: ImageWithLabelView!
    @IBOutlet weak var authorView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorInfoLabel: UILabel!
    @IBOutlet weak var descLabelHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: RepositoryDetailsHeaderViewModel? = nil {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGUI()
    }
    
    private func setupGUI() {
        authorImageView.tintColor = .gray
        authorLabel.text = AppStrings.author.localized
        addTapGestureRecognizerForAuthor()
    }
            
    private func addTapGestureRecognizerForAuthor() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        tapGesture.cancelsTouchesInView = true
        authorView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        viewModel?.userTappedAvatarImage()
    }
    
    func setupView(viewModel: RepositoryDetailsHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    private func fillData() {
        guard let vm = viewModel else { return }
        titleLabel.text = vm.title
        descLabel.text = vm.desc
        descLabelHeightConstraint.constant = vm.descLabeHeight        
        urlLabel.text = vm.url
        starsView.setupView(icon: vm.starsIcon, title: vm.stars)
        forksView.setupView(icon: vm.forksIcon, title: vm.forks)
        watchersView.setupView(icon: vm.watchersIcon, title: vm.watchers)
        issuesView.setupView(icon: vm.issuesIcon, title: vm.issues)
        authorImageView.sd_setImage(with: vm.authorTumbnailURL, placeholderImage: vm.placeholderImage)
        authorNameLabel.text = vm.authorName
        authorInfoLabel.text = vm.authorInfo        
    }
}


// MARK: - Reusable
extension RepositoryDetailsHeaderView: Reusable {
    static var estimatedHeight: CGFloat {
        return 273.0
    }
}

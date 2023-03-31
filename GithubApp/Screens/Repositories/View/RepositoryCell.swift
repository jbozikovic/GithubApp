//
//  RepositoryCell.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import SDWebImage


class RepositoryCell: UITableViewCell {
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var issuesView: ImageWithLabelView!
    @IBOutlet weak var forksView: ImageWithLabelView!
    @IBOutlet weak var watchersView: ImageWithLabelView!
        
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var viewModel: RepositoryCellViewModel? = nil {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        handleViewsVisibility(hidden: true)
    }

    private func setupGUI() {
        backgroundColor = .clear
        setupActivityIndicatorView()
        handleViewsVisibility(hidden: true)
        addTapGestureRecognizerForAvatarImage()        
    }
    
    private func setupActivityIndicatorView() {
        activityIndicatorView?.style = .large
        activityIndicatorView?.hidesWhenStopped = true
    }
    
    private func addTapGestureRecognizerForAvatarImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        tapGesture.cancelsTouchesInView = true
        authorImageView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        viewModel?.userTappedAvatarImage()
    }

    func setupCell(viewModel: RepositoryCellViewModel?) {
        guard viewModel != nil else {
            handleViewsVisibility(hidden: true)
            return
        }
        self.viewModel = viewModel
    }
    
    private func handleViewsVisibility(hidden: Bool) {
        authorImageView?.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        repoNameLabel?.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        authorLabel.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        watchersView.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        forksView.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        issuesView.alpha = hidden ? AppUI.alphaHidden : AppUI.alphaVisible
        if hidden {
            activityIndicatorView.startAnimating()
        }
    }

    private func fillData() {
        activityIndicatorView.stopAnimating()
        guard let vm = self.viewModel else { return }
        repoNameLabel.text = vm.title
        authorLabel.attributedText = vm.author
        authorImageView.sd_setImage(with: vm.authorTumbnailURL, placeholderImage: vm.placeholderImage)        
        authorImageView.tintColor = .gray
        watchersView.setupView(icon: vm.watchersIcon, title: vm.watchers)
        forksView.setupView(icon: vm.forksIcon, title: vm.forks)
        issuesView.setupView(icon: vm.issuesIcon, title: vm.issues)
        handleViewsVisibility(hidden: false)
    }    
}


//  MARK: - Reusable
extension RepositoryCell: Reusable {
    static var estimatedHeight: CGFloat {
        return 118.0
    }
}





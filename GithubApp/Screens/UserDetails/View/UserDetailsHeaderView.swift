//
//  UserDetailsHeaderView.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - UserDetailsHeaderViewConstants
private struct UserDetailsHeaderViewConstants {
    private init() {}

    static let titleNumberOfLines: Int = 2
    static let descNumberOfLines: Int = 3
    static let offset: CGFloat = 10.0
    static let avatarSize: CGFloat = 150.0
    static let leadingTrailingOffset: CGFloat = 20.0
    static let labelHeight: CGFloat = 21.0
    static let statisticViewHeight: CGFloat = 20.0
}


// MARK: - UserDetailsHeaderView
class UserDetailsHeaderView: UITableViewHeaderFooterView {
    lazy var avatarImageView = UIImageView(frame: .zero)
    lazy var titleLabel = UILabel(frame: .zero)
    lazy var followersView = ImageWithLabelView(frame: .zero)
    lazy var reposView = ImageWithLabelView(frame: .zero)
    lazy var descLabel = UILabel(frame: .zero)
    
    private var viewModel: UserDetailsHeaderViewModel? = nil {
        didSet {
            fillData()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupGUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
    func setupView(viewModel: UserDetailsHeaderViewModel) {
        self.viewModel = viewModel
    }
    
    private func fillData() {
        guard let vm = viewModel else { return }
        avatarImageView.sd_setImage(with: vm.avatarURL, placeholderImage: vm.placeholderImage)
        titleLabel.text = vm.title
        descLabel.text = vm.desc
        followersView.setupView(icon: vm.followersIcon, title: vm.followers)
        reposView.setupView(icon: vm.repositoriesIcon, title: vm.publicRepos)
    }
}

// MARK: - Setup GUI
private extension UserDetailsHeaderView {
    func setupGUI() {
        addSubviews()
        avatarImageView.tintColor = .gray
        setupLabel(titleLabel, font: AppUI.titleFont, textColor: AppUI.titleFontColor, numberOfLines: UserDetailsHeaderViewConstants.titleNumberOfLines)
        setupLabel(descLabel, font: AppUI.defaultFont, textColor: AppUI.bodyFontColor, numberOfLines: UserDetailsHeaderViewConstants.descNumberOfLines)
        followersView.translatesAutoresizingMaskIntoConstraints = false
        reposView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    func setupLabel(_ label: UILabel, font: UIFont, textColor: UIColor, numberOfLines: Int) {
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.text = ""
    }
    
    func addSubviews() {
        [avatarImageView, titleLabel, descLabel, followersView, reposView].forEach { subView in
            addSubview(subView)
        }
    }
}


// MARK: - Setup constraints
private extension UserDetailsHeaderView {
    func setupConstraints() {
        setupAvatarConstraints()
        setupTitleConstraints()
        setupDescConstraints()
        setupFollowersConstraints()
        setupReposConstraints()
    }
    
    func setupAvatarConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UserDetailsHeaderViewConstants.offset)
            make.leading.equalToSuperview().offset(UserDetailsHeaderViewConstants.leadingTrailingOffset)
            make.width.equalTo(UserDetailsHeaderViewConstants.avatarSize)
            make.height.equalTo(UserDetailsHeaderViewConstants.avatarSize)
        }
    }
    
    func setupTitleConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UserDetailsHeaderViewConstants.offset)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UserDetailsHeaderViewConstants.offset)
            make.trailing.equalToSuperview().offset(-UserDetailsHeaderViewConstants.leadingTrailingOffset)
            make.height.greaterThanOrEqualTo(UserDetailsHeaderViewConstants.labelHeight)
        }
    }
    
    func setupDescConstraints() {
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(reposView.snp.bottom).offset(UserDetailsHeaderViewConstants.offset)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.greaterThanOrEqualTo(UserDetailsHeaderViewConstants.labelHeight)
            make.trailing.equalToSuperview().offset(-UserDetailsHeaderViewConstants.leadingTrailingOffset)
        }
    }
    
    func setupFollowersConstraints() {
        followersView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UserDetailsHeaderViewConstants.offset)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-UserDetailsHeaderViewConstants.leadingTrailingOffset)
            make.height.equalTo(UserDetailsHeaderViewConstants.statisticViewHeight)
        }
    }
    
    func setupReposConstraints() {
        reposView.snp.makeConstraints { make in
            make.top.equalTo(followersView.snp.bottom).offset(UserDetailsHeaderViewConstants.offset)
            make.leading.equalTo(followersView.snp.leading)
            make.trailing.equalToSuperview().offset(-UserDetailsHeaderViewConstants.leadingTrailingOffset)
            make.height.equalTo(UserDetailsHeaderViewConstants.statisticViewHeight)
        }
    }
}


// MARK: - Reusable
extension UserDetailsHeaderView: Reusable {
    static var estimatedHeight: CGFloat {
        return 180.0
    }
}

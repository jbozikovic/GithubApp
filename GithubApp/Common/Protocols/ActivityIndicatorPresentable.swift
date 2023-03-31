//
//  ActivityIndicatorPresentable.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 30.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresentable {
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ActivityIndicatorPresentable where Self: UIViewController {
    func showActivityIndicator() {
        guard let activityIndicator = getActivityIndicator() else {
            createActivityIndicatorView()
            return
        }
        activityIndicator.startAnimating()
    }
        
    func hideActivityIndicator() {
        getActivityIndicator()?.stopAnimating()
    }

    private func getActivityIndicator() -> UIActivityIndicatorView? {
        return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
    
    private func createActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .black
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
}

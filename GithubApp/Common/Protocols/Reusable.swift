//
//  Reusable.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
    static var estimatedHeight: CGFloat { get }
}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

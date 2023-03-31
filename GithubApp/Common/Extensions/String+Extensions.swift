//
//  String+Extensions.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func boldText(_ boldText: String, fontSize: CGFloat = AppUI.bodyFontSize) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let boldRange = (self as NSString).range(of: boldText)
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize, weight: .bold)], range: boldRange)
        return attributedString
    }
}


// MARK: - Optional isNilOrEmpty
extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        guard let unwrapped = self else { return true }
        return unwrapped.isEmpty
    }
}


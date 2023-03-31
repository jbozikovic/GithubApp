//
//  Int+Extensions.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

extension Int {
    func shortened() -> String {
        let num = Double(self)
        switch num {
        case ..<1000:
            return String(format: "%.0f", locale: Locale.current, num)
        case 1000 ..< 999_999:
            return String(format: "%.1fK", locale: Locale.current, num / 1000).replacingOccurrences(of: ".0", with: "")
        default:
            return String(format: "%.1fM", locale: Locale.current, num / 1000000).replacingOccurrences(of: ".0", with: "")
        }
    }
}

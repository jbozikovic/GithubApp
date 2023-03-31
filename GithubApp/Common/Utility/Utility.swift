//
//  Utility.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    //  MARK: - String
    static func stringNilOrEmpty(string: String?) -> Bool {
        return (string ?? "").isEmpty
    }
        
    static func generateUUIDString() -> String {
        return UUID().uuidString
    }
    
    //  MARK: - Print if DEBUG
    static func printIfDebug(string: String) {
        #if DEBUG
        print(string)
        #endif
    }
            
    //  MARK: - UIBarButtonItem
    static func createBarButtonItem(image: UIImage?, target: Any, action: Selector, identifier: String) -> UIBarButtonItem {
        let btn = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        btn.accessibilityIdentifier = identifier
        btn.tintColor = .gray
        return btn
    }
    
    public static func isValidUrl(urlString: String) -> URL? {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return nil }
        return url
    }
}


//  MARK: - Reachability, Internet connection
extension Utility {
    static var hasInternetConnection: Bool {
        guard let reachability = Reachability(), reachability.isConnected else {
            return false
        }
        return true
    }
}

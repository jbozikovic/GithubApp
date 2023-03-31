//
//  Reachability+Extensions.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 22.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

extension Reachability {
    var isReachableOnWiFi: Bool {
        return self.connection == .wifi
    }
    
    var isConnected: Bool {
        return self.connection != .none
    }
}

//
//  AppPermissionsService.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 01.04.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Foundation

//  MARK: - AppPermissionsProtocol
protocol AppPermissionsProtocol {
    var canNavigateToRepoDetails: Bool { get }
    var canNavigateToUserDetails: Bool { get }
}

//  MARK: - AppPermissionsService
class AppPermissionsService: AppPermissionsProtocol {
    var canNavigateToRepoDetails: Bool{
        #if !TEST
        return true
        #else
        return false
        #endif
    }
    
    var canNavigateToUserDetails: Bool {
        #if PRODUCTION
        return true
        #else
        return false
        #endif
    }
}

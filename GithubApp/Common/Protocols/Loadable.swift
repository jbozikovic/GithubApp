//
//  Loadable.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 30.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import Combine

protocol Loadable: AnyObject {
    var isLoading: Bool { get set }
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> { get }
    func updateLoadingStatus()
}

extension Loadable {
    func updateLoadingStatus() {
        isLoading = !isLoading
        loadingStatusUpdated.send(isLoading)
    }
}

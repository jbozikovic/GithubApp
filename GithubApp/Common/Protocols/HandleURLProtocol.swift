//
//  HandleURLProtocol.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 28.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

protocol HandleURLProtocol {
    func openURLInExternalBrowser(urlString: String)
}

extension HandleURLProtocol {
    func openURLInExternalBrowser(urlString: String) {
        guard let url = Utility.isValidUrl(urlString: urlString) else { return }
        UIApplication.shared.open(url)
    }
}


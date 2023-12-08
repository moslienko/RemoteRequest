//
//  RequestType.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

enum RequestType: CaseIterable {
    case fetchingItems, fetchItem
    
    var title: String {
        switch self {
        case .fetchingItems:
            return "[GET] Fetch items"
        case .fetchItem:
            return "[GET] Fetch item"
        }
    }
}

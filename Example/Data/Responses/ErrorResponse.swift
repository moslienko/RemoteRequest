//
//  ErrorResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 10.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

struct ErrorResponse: RestError {
    var error: String
}

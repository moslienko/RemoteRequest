//
//  RestErrorResponse.swift
//  RemoteRequest
//
//  Created by Pavel Moslienko on 10.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public typealias RegRestErrorResponse = RestErrorResponse<String?>

public struct RestErrorResponse<T: Codable>: RestError {
    let code: Int
    let message: String
    let data: T?
}

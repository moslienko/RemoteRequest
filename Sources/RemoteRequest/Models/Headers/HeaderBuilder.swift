//
//  HeaderBuilder.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 13.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public enum HeaderBuilder {
    case custom(key: String, value: String), tokenAuth(_ token: String),
         basicAuth(username: String, password: String), jwtAuth(_ jwtToken: String)
    
    public var header: [String: String] {
        switch self {
        case let .custom(key, value):
            return [key: value]
        case let .tokenAuth(token):
            return ["Authorization": "Bearer \(token)"]
        case let .basicAuth(username, password):
            let credentials = "\(username):\(password)"
            let base64Credentials = Data(credentials.utf8).base64EncodedString()
            return ["Authorization": "Basic \(base64Credentials)"]
        case let .jwtAuth(jwtToken):
            return ["Authorization": "JWT \(jwtToken)"]
        }
    }
}

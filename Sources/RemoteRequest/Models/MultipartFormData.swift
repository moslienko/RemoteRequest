//
//  MultipartFormData.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public struct MultipartFormData {
    let httpBody: Data
    let contentType: String

    public init(httpBody: Data, contentType: String) {
        self.httpBody = httpBody
        self.contentType = contentType
    }
}

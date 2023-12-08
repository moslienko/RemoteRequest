//
//  CreatePostRequest.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

struct CreatePostRequest: InputBodyObject {
    var userId: Int
    var title: String
    var body: String

    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case title = "title"
        case body = "body"
    }
}

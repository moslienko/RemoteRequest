//
//  PostResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class PostResponse: ObjectMappable {
    
    typealias MappableOutput = PostModel
    
    var userId: Int
    var id: Int
    var title: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
    
    func createModel() -> PostModel? {
        return PostModel(
            userId: self.userId,
            id: self.id,
            title: self.title,
            body: self.body
        )
    }
}

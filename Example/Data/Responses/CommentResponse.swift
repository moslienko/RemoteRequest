//
//  CommentResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class CommentResponse: ObjectMappable {
    
    typealias MappableOutput = CommentModel
    
    var id: Int
    var name: String
    var email: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case body = "body"
    }
    
    func createModel() -> CommentModel? {
        return CommentModel(
            id: self.id,
            name: self.name,
            email: self.email,
            body: self.body
        )
    }
}

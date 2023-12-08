//
//  TodoResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class TodoResponse: ObjectMappable {
    
    typealias MappableOutput = TodoModel
    
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case completed = "completed"
    }
    
    func createModel() -> TodoModel? {
        return TodoModel(
            userId: self.userId,
            id: self.id,
            title: self.title,
            completed: self.completed
        )
    }
}

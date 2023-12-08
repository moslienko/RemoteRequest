//
//  Routes.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

struct Routes {
    @Route<TodoResponse, TodoModel>("https://jsonplaceholder.typicode.com/todos/1", method: .get)
    var fetchItem: URLRequest
    
    @Route<[TodoResponse], [TodoModel]>("https://jsonplaceholder.typicode.com/todos", method: .get)
    var fetchItems: URLRequest
    
    func fetchItem(completion: @escaping (Result<TodoModel, Error>) -> Void) {
        _fetchItem.runRequest(completion: completion)
    }
    
    func fetchItems(completion: @escaping (Result<[TodoModel], Error>) -> Void) {
        _fetchItems.runRequest(completion: completion)
    }
}

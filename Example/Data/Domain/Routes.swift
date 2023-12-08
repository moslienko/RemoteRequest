//
//  Routes.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

#warning("todo id as parameter")
struct Routes {
    @Route<PostResponse, PostModel>("https://jsonplaceholder.typicode.com/posts/1", method: .get)
    var fetchPost: URLRequest
    
    @Route<[PostResponse], [PostModel]>("https://jsonplaceholder.typicode.com/posts", method: .get)
    var fetchPosts: URLRequest
    
    @Route<IdendifierResponse, IdendifierModel>("https://jsonplaceholder.typicode.com/posts", method: .post)
    var createPost: URLRequest
    
    @Route<IdendifierResponse, IdendifierModel>("https://jsonplaceholder.typicode.com/posts/1", method: .put)
    var updatePost: URLRequest
    
    @Route<EmptyResponse, Any>("https://jsonplaceholder.typicode.com/posts/1", method: .delete)
    var deletePost: URLRequest
    
    @Route<[PostResponse], [PostModel]>("https://jsonplaceholder.typicode.com/posts?userId=1", method: .get)
    var fetchingFilteresPosts: URLRequest
    
    @Route<[CommentResponse], [CommentModel]>("https://jsonplaceholder.typicode.com/posts/1/comments", method: .get)
    var fetchComments: URLRequest
    
    func fetchPost(completion: @escaping (Result<PostModel, Error>) -> Void) {
        _fetchPost.runRequest(completion: completion)
    }
    
    func fetchPosts(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        _fetchPosts.runRequest(completion: completion)
    }
    
    mutating func createPost(_ post: CreatePostRequest, completion: @escaping (Result<IdendifierModel, Error>) -> Void) {
        _createPost.setInputData(parameters: nil, body: post)
        _createPost.runRequest(completion: completion)
    }
    
    mutating func updatePost(_ post: UpdatePostRequest, completion: @escaping (Result<IdendifierModel, Error>) -> Void) {
        _createPost.setInputData(parameters: nil, body: post)
        _updatePost.runRequest(completion: completion)
    }
    
    func deletePost(completion: @escaping (Result<Any, Error>) -> Void) {
        _deletePost.runRequest(completion: completion)
    }
    
    func fetchingFilteresPosts(completion: @escaping (Result<[PostModel], Error>) -> Void) {
        _fetchingFilteresPosts.runRequest(completion: completion)
    }
    
    func fetchComments(completion: @escaping (Result<[CommentModel], Error>) -> Void) {
        _fetchComments.runRequest(completion: completion)
    }
}

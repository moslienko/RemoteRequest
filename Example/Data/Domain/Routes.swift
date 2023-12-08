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
    private static var baseURL = "https://jsonplaceholder.typicode.com"
    
    @Route<[PostResponse], [PostModel]>(Routes.baseURL + "/posts", method: .get)
    var fetchPosts: URLRequest
    
    func fetchPost(postID: Int, completion: @escaping (ResultData<PostModel>) -> Void) {
        @Route<PostResponse, PostModel>(Routes.baseURL + "/posts/\(postID)", method: .get)
        var fetchPost: URLRequest
        
        _fetchPost.runRequest(completion: completion)
    }
    
    func fetchPosts(completion: @escaping (ResultData<[PostModel]>) -> Void) {
        _fetchPosts.runRequest(completion: completion)
    }
    
    func createPost(_ post: CreatePostRequest, completion: @escaping (ResultData<IdendifierModel>) -> Void) {
        @Route<IdendifierResponse, IdendifierModel>(Routes.baseURL + "/posts", method: .post, body: post)
        var createPost: URLRequest
        
        _createPost.runRequest(completion: completion)
    }
    
    func updatePost(_ post: UpdatePostRequest, completion: @escaping (ResultData<IdendifierModel>) -> Void) {
        @Route<IdendifierResponse, IdendifierModel>(Routes.baseURL + "/posts/\(post.id)", method: .put, body: post)
        var updatePost: URLRequest
        
        _updatePost.runRequest(completion: completion)
    }
    
    func deletePost(postID: Int, completion: @escaping (ResultData<Any>) -> Void) {
        @Route<EmptyResponse, Any>(Routes.baseURL + "/posts/\(postID)", method: .delete)
        var deletePost: URLRequest
        
        _deletePost.runRequest(completion: completion)
    }
    
    func fetchingFilteresPosts(userId: Int, completion: @escaping (ResultData<[PostModel]>) -> Void) {
        @Route<[PostResponse], [PostModel]>(Routes.baseURL + "/posts?userId=\(userId)", method: .get)
        var fetchingFilteresPosts: URLRequest
        
        _fetchingFilteresPosts.runRequest(completion: completion)
    }
    
    func fetchComments(postId: Int,completion: @escaping (ResultData<[CommentModel]>) -> Void) {
        @Route<[CommentResponse], [CommentModel]>(Routes.baseURL + "/posts/\(postId)/comments", method: .get)
        var fetchComments: URLRequest
        
        _fetchComments.runRequest(completion: completion)
    }
}

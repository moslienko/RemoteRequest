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
    
    @Route<[PostResponse], [PostModel], RegRestErrorResponse>(Routes.baseURL + "/posts", method: .get, headers: Routes.SampleHeaders().header)
    var fetchPosts: URLRequest
    
    func fetchPost(postID: Int, completion: @escaping (ResultData<PostModel>) -> Void) {
        @Route<PostResponse, PostModel, RegRestErrorResponse>(Routes.baseURL + "/posts/\(postID)", method: .get)
        var fetchPost: URLRequest
        _fetchPost.runRequest(completion: completion)
    }
    
    func fetchPosts(completion: @escaping (ResultData<[PostModel]>) -> Void) {
        _fetchPosts.runRequest(completion: completion)
    }
    
    func createPost(_ postRequest: CreatePostRequest, completion: @escaping (ResultData<IdendifierModel>) -> Void) {
        @POST<IdendifierResponse, IdendifierModel, RegRestErrorResponse>(Routes.baseURL + "/posts", body: postRequest)
        var createPost: RouteRestProtocol
        
        createPost.runRequest(completion: completion)
    }
    
    func updatePost(_ post: UpdatePostRequest, completion: @escaping (ResultData<IdendifierModel>) -> Void) {
        @Route<IdendifierResponse, IdendifierModel, RegRestErrorResponse>(Routes.baseURL + "/posts/\(post.id)", method: .put, body: post)
        var updatePost: URLRequest
        
        _updatePost.runRequest(completion: completion)
    }
    
    func deletePost(postID: Int, completion: @escaping (ResultData<Any>) -> Void) {
        @Route<EmptyResponse, Any, RegRestErrorResponse>(Routes.baseURL + "/posts/\(postID)", method: .delete)
        var deletePost: URLRequest
        
        _deletePost.runRequest(completion: completion)
    }
    
    func fetchingFilteresPosts(userId: Int, completion: @escaping (ResultData<[PostModel]>) -> Void) {
        @Route<[PostResponse], [PostModel], RegRestErrorResponse>(Routes.baseURL + "/posts?userId=\(userId)", method: .get)
        var fetchingFilteresPosts: URLRequest
        
        _fetchingFilteresPosts.runRequest(completion: completion)
    }
    
    func fetchComments(postId: Int,completion: @escaping (ResultData<[CommentModel]>) -> Void) {
        @GET<[CommentResponse], [CommentModel], RegRestErrorResponse>(Routes.baseURL + "/posts/\(postId)/comments")
        var request: RouteRestProtocol
        request.runRequest(completion: completion)
    }
    
    func fetchCommentsWithCache(postId: Int,completion: @escaping (ResultData<[CommentModel]>) -> Void) {
        @GET<[CommentResponse], [CommentModel], RegRestErrorResponse>(Routes.baseURL + "/posts/\(postId)/comments", options: RouteOptions(isNeedUseCache: true))
        var request: RouteRestProtocol
        
        CacheManager.shared.shouldAutoCleanCache = true
        CacheManager.shared.cacheExpirationInterval = 1600
        
        request.runRequest(completion: completion)
    }
    
    func uploadFile(_ file: InputFile, completion: @escaping (ResultData<Any>) -> Void, progressHandler: ((Double) -> Void)? = nil) {
        @UPLOAD<EmptyResponse, Any, RegRestErrorResponse>("https://postman-echo.com/post", inputFile: file)
        var uploadPost: RouteUploadProtocol
        
        uploadPost.runUploadRequest(completion: completion, progressHandler: progressHandler)
    }
    
    @available(iOS 15.0, *)
    func fetchPostsAwait() async throws -> Result<[PostModel], Error> {
        @Route<[PostResponse], [PostModel], RegRestErrorResponse>(Routes.baseURL + "/posts", method: .get)
        var fetchPost: URLRequest
        
        return try await _fetchPost.runRequest()
    }
    
    func fetchWithNotFoundErr(completion: @escaping (ResultData<PostModel>) -> Void) {
        @Route<PostResponse, PostModel, RegRestErrorResponse>(Routes.baseURL + "/error", method: .get)
        var fetchPost: URLRequest
        
        _fetchPost.runRequest(completion: completion)
    }
    
    func fetchWithCustomError(name: String,completion: @escaping (ResultData<PostModel>) -> Void) {
        @GET<PostResponse, PostModel, ErrorResponse>("https://api.genderize.io/?named=\(name)", options: RouteOptions(loggingLevels: .errors))
        var request: RouteRestProtocol
        request.runRequest(completion: completion)
    }
}

private extension Routes {
    
    struct SampleHeaders {
        @Header(.jwtAuth("eyJhbG"))
        @Header(.custom(key: "AppClient", value: "iOS"))
        var header: [String: String] = [:]
        
        init() {
            self.header = [:]
        }
    }
}

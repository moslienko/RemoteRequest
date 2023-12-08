//
//  ExampleViewControllerModel.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class ExampleViewControllerModel {
    
    var onBeginLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    var onDisplayRequestResult: ((String) -> Void)?
    
    func handleRequest(_ request: RequestType) {
        let routes = Routes()
        
        DispatchQueue.main.async {
            self.onBeginLoading?()
        }
        
        switch request {
        case .fetchingPosts:
            routes.fetchPosts { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchPost:
            routes.fetchPost(postID: 1) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .createPost:
            routes.createPost(CreatePostRequest(userId: 1, title: "Hello", body: "world!")) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .updatePost:
            routes.updatePost(UpdatePostRequest(id: 1, userId: 1, title: "Updated title", body: "Updated body")) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .deletePost:
            routes.deletePost(postID: 3) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchingFilteresPosts:
            routes.fetchingFilteresPosts(userId: 5) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchComments:
            routes.fetchComments(postId: 7) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        }
    }
}

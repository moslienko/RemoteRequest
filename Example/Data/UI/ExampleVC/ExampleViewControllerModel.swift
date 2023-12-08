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
        DispatchQueue.main.async {
            self.onBeginLoading?()
        }
        
        switch request {
        case .fetchingPosts:
            Routes().fetchPosts { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchPost:
            Routes().fetchPost { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .createPost:
            var routes = Routes()
            routes.createPost(CreatePostRequest(userId: 1, title: "Hello", body: "world!")) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .updatePost:
            var routes = Routes()
            routes.updatePost(UpdatePostRequest(id: 0, userId: 1, title: "Updated title", body: "Updated body")) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .deletePost:
            Routes().deletePost { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchingFilteresPosts:
            Routes().fetchingFilteresPosts { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchComments:
            Routes().fetchComments { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        }
    }
}

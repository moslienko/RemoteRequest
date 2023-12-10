//
//  ExampleViewControllerModel.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest
import UIKit

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
        case .uploadFile:
            guard let imgData = UIImage(named: "swift")?.pngData() else {
                return
            }
            let inputFile = InputFile(data: imgData, filename: "swift.png", fileKey: "file", mimeType: "image/png")
            routes.uploadFile(inputFile) { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            } progressHandler: { val in
                DispatchQueue.main.async {
                    self.onDisplayRequestResult?("Progress: \(val)")
                }
            }
        case .fetchPostsAwait:
            if #available(iOS 15.0, *) {
                Task {
                    let result = try await routes.fetchPostsAwait()
                    switch result {
                    case let .success(models):
                        DispatchQueue.main.async {
                            self.onFinishLoading?()
                            self.onDisplayRequestResult?("List: \(models)")
                        }
                    case let .failure(failure):
                        DispatchQueue.main.async {
                            self.onFinishLoading?()
                            self.onDisplayRequestResult?("Error: \(failure)")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("Need iOS >= 15")
                }
            }
        case .notFoundErr:
            routes.fetchWithNotFoundErr { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    switch result {
                    case let .success(model):
                        self.onDisplayRequestResult?("\(model)")
                    case let .failure(error):
                        switch (error as NSError).code {
                        case 404:
                            self.onDisplayRequestResult?("⚠️ Not found")
                        default:
                            self.onDisplayRequestResult?("\(result)")
                        }
                    }
                }
            }
        case .customErr:
            routes.fetchWithCustomError(name: "Ann") { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    switch result {
                    case let .success(model):
                        self.onDisplayRequestResult?("\(model)")
                    case let .failure(error):
                        if let customError = error as? ErrorResponse {
                            self.onDisplayRequestResult?("Error: \(customError.error)")
                        } else {
                            self.onDisplayRequestResult?("\(error)")
                        }
                    }
                }
            }
        }
    }
}

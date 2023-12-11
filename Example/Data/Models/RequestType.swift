//
//  RequestType.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

enum RequestType: CaseIterable {
    case fetchingPosts, fetchPost, createPost, updatePost, deletePost, fetchingFilteresPosts, fetchComments, fetchCommentsWitchCash, uploadFile, fetchPostsAwait, notFoundErr, customErr
    
    var title: String {
        switch self {
        case .fetchingPosts:
            return "[GET] Fetch posts"
        case .fetchPost:
            return "[GET] Fetch post"
        case .createPost:
            return "[POST] Create post"
        case .updatePost:
            return "[PATCH] Update post"
        case .deletePost:
            return "[DELETE] Delete post"
        case .fetchingFilteresPosts:
            return "[GET] Fetch posts with filter"
        case .fetchComments:
            return "[GET] Fetch post comments"
        case .fetchCommentsWitchCash:
            return "[GET] Fetch post comments with cache"
        case .uploadFile:
            return "[POST] Multiform upload data"
        case .fetchPostsAwait:
            return "[GET] Fetch posts async/await"
        case .notFoundErr:
            return "[GET] Fetch posts, 404 error"
        case .customErr:
            return "[GET] Fetch post with custom error response"
        }
    }
}

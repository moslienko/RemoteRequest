//
//  RequestType.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

enum RequestType: CaseIterable {
    case fetchingPosts, fetchPost, createPost, updatePost, deletePost, fetchingFilteresPosts, fetchComments
    
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
        }
    }
}

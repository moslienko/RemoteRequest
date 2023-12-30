//
//  UploadRequestProtocol.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public protocol UploadRequestProtocol {
    associatedtype Output: Decodable
    associatedtype MappableOutput
    
    var route: RouteUploadProtocol {get set} //Route<Output, MappableOutput> { get }
    
    init(_ path: String, headers: [String: String], parameters: [String: Any]?, inputFile: InputFile, options: RouteOptions)
}

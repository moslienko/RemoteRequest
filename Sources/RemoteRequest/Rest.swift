//
//  Rest.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

@propertyWrapper
public struct GET<Output: Decodable, MappableOutput, ErrorType: RestError>: HTTPRequestProtocol {
    
    public var route: RouteRestProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, isNeedUseCache: Bool = false) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .get, headers: headers, parameters: parameters, body: body, isNeedUseCache: isNeedUseCache)
    }
    
    public var wrappedValue: RouteRestProtocol {
        route
    }
}

@propertyWrapper
public struct POST<Output: Decodable, MappableOutput, ErrorType: RestError>: HTTPRequestProtocol {
    
    public var route: RouteRestProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, isNeedUseCache: Bool = false) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .post, headers: headers, parameters: parameters, body: body, isNeedUseCache: isNeedUseCache)
    }
    
    public var wrappedValue: RouteRestProtocol {
        route
    }
}

@propertyWrapper
public struct PATCH<Output: Decodable, MappableOutput, ErrorType: RestError>: HTTPRequestProtocol {
    
    public var route: RouteRestProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, isNeedUseCache: Bool = false) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .patch, headers: headers, parameters: parameters, body: body, isNeedUseCache: isNeedUseCache)
    }
    
    public var wrappedValue: RouteRestProtocol {
        route
    }
}

@propertyWrapper
public struct PUT<Output: Decodable, MappableOutput, ErrorType: RestError>: HTTPRequestProtocol {
    
    public var route: RouteRestProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, isNeedUseCache: Bool = false) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .put, headers: headers, parameters: parameters, body: body, isNeedUseCache: isNeedUseCache)
    }
    
    public var wrappedValue: RouteRestProtocol {
        route
    }
}

@propertyWrapper
public struct DELETE<Output: Decodable, MappableOutput, ErrorType: RestError>: HTTPRequestProtocol {
    
    public var route: RouteRestProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, body: InputBodyObject? = nil, isNeedUseCache: Bool = false) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .delete, headers: headers, parameters: parameters, body: body, isNeedUseCache: isNeedUseCache)
    }
    
    public var wrappedValue: RouteRestProtocol {
        route
    }
}

@propertyWrapper
public struct UPLOAD<Output: Decodable, MappableOutput, ErrorType: RestError>: UploadRequestProtocol {
    
    public var route: RouteUploadProtocol
    
    public init(_ path: String, headers: [String: String] = [:], parameters: [String: Any]? = nil, inputFile: InputFile) {
        self.route = Route<Output, MappableOutput, ErrorType>(path, method: .post, headers: headers, parameters: parameters, inputFile: inputFile)
    }
    
    public var wrappedValue: RouteUploadProtocol {
        route
    }
}

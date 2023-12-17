//
//  RouteOptions.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 17.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public class RouteSessionOptions {
    
    public static let current = RouteSessionOptions()
    public var options = RouteOptions.defaultOptions
    
    private init() {}
}

public struct RouteOptions {
    
    public var timeoutInterval: TimeInterval
    public var isCompressionEnabled: Bool
    public var loggingLevels: LoggingLevels
    public var isNeedUseCache: Bool
    public var additionalHeaders: [String: String]
    
    public init(
        timeoutInterval: TimeInterval = RouteSessionOptions.current.options.timeoutInterval,
        isCompressionEnabled: Bool = RouteSessionOptions.current.options.isCompressionEnabled,
        loggingLevels: LoggingLevels = RouteSessionOptions.current.options.loggingLevels,
        isNeedUseCache: Bool = RouteSessionOptions.current.options.isNeedUseCache,
        additionalHeaders: [String: String] = RouteSessionOptions.current.options.additionalHeaders
    ) {
        self.timeoutInterval = timeoutInterval
        self.isCompressionEnabled = isCompressionEnabled
        self.loggingLevels = loggingLevels
        self.isNeedUseCache = isNeedUseCache
        self.additionalHeaders = additionalHeaders
    }
    
    public static var defaultOptions: RouteOptions {
        RouteOptions(
            timeoutInterval: 30.0,
            isCompressionEnabled: false,
            loggingLevels: .errors,
            isNeedUseCache: false,
            additionalHeaders: [:]
        )
    }
}

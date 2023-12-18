//
//  EmptyResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public class EmptyResponse: ObjectMappable {
    
    public typealias MappableOutput = Any
    
    public func createModel() -> Any? {
        ()
    }
}

//
//  Appendable.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 13.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public protocol Appendable {
    func appending(data: HeaderBuilder) -> Self
}

extension Dictionary: Appendable where Key == String, Value == String {
    public func appending(data: HeaderBuilder) -> Dictionary<String, String> {
        var result = self
        data.header.forEach({ (key, val) in
            result[key] = val
        })
        return result
    }
}

//
//  Header.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 12.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Header<T: Appendable> {
    private(set) var value: T
    public let toAppend: HeaderBuilder

    public var wrappedValue: T {
        get { value }
        set { value = newValue.appending(data: toAppend) }
    }

    public init(wrappedValue: T, _ toAppend: HeaderBuilder) {
        self.value = wrappedValue
        self.toAppend = toAppend
    }
}

extension Header: Appendable {
    public func appending(data: HeaderBuilder) -> Header<T> {
        return Header(wrappedValue: self.wrappedValue.appending(data: data), self.toAppend)
    }
}

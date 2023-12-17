//
//  URLRequest+Ext.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 17.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

extension URLRequest {
    
    func debug() {
        print("Send request - \(self.httpMethod ?? "Incorrect method") \(self.url?.absoluteString ?? "Incorrect url")")
        print("Headers - \(self.allHTTPHeaderFields ?? [:])")
        if let data = self.httpBody,
           let bodyStr = String(data: data, encoding: .utf8) {
            print("Body - \(bodyStr)")
        }
    }
}

//
//  RouteRestProtocol.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public protocol RouteRestProtocol {
    func runRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void)
    func getRequest() -> URLRequest
    
    @available(iOS 15.0, *)
    func runRequest<MappableOutput>() async throws -> Result<MappableOutput, Error>
}

//
//  RouteUploadProtocol.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public protocol RouteUploadProtocol {
    func runUploadRequest<MappableOutput>(completion: @escaping (ResultData<MappableOutput>) -> Void, progressHandler: ((Double) -> Void)?)
}

//
//  InputFile.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 09.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public struct InputFile {
    let data: Data
    let filename: String
    let fileKey: String
    let mimeType: String

    public init(data: Data, filename: String, fileKey: String, mimeType: String) {
        self.data = data
        self.filename = filename
        self.fileKey = fileKey
        self.mimeType = mimeType
    }
}

//
//  IdendifierResponse.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class IdendifierResponse: ObjectMappable {
    
    typealias MappableOutput = IdendifierModel
    
    var id: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
    
    func createModel() -> IdendifierModel? {
        return IdendifierModel(
            id: self.id
        )
    }
}

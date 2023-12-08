//
//  ExampleViewControllerModel.swift
//  Example
//
//  Created by Pavel Moslienko on 08.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import RemoteRequest

class ExampleViewControllerModel {
    
    var onBeginLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    var onDisplayRequestResult: ((String) -> Void)?
    
    let routes = Routes()
    
    func handleRequest(_ request: RequestType) {
        DispatchQueue.main.async {
            self.onBeginLoading?()
        }
        
        switch request {
        case .fetchingItems:
            routes.fetchItems { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        case .fetchItem:
            routes.fetchItem { result in
                DispatchQueue.main.async {
                    self.onFinishLoading?()
                    self.onDisplayRequestResult?("\(result)")
                }
            }
        }
    }
}

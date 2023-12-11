//
//  CacheManager.swift
//  RemoteRequest-iOS
//
//  Created by Pavel Moslienko on 10.12.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

public class CacheManager {
    
    public static let shared = CacheManager()
    
    private var cache = NSCache<NSURL, NSData>()
    private var expirationDates = [NSURL: Date]()
    
    public var shouldAutoCleanCache = true
    public var cacheExpirationInterval: TimeInterval = 3600
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
}

// MARK: - Module public methods
public extension CacheManager {
    
    func saveDataToCache(_ data: Data, for url: URL) {
        cache.setObject(data as NSData, forKey: url as NSURL)
        
        let expirationDate = Date().addingTimeInterval(cacheExpirationInterval)
        expirationDates[url as NSURL] = expirationDate
    }
    
    func fetchDataFromCache(for url: URL) -> Data? {
        guard let cachedObject = cache.object(forKey: url as NSURL) else {
            return nil
        }
        if let expirationDate = expirationDates[url as NSURL], expirationDate < Date() {
            removeDataFromCache(for: url)
            return nil
        }
        
        return cachedObject as Data
    }
    
    func removeDataFromCache(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
        expirationDates[url as NSURL] = nil
    }
    
    func clearCache() {
        cache.removeAllObjects()
        expirationDates.removeAll()
    }
}

// MARK: - Module private methods
private extension CacheManager {
    
    func autoCleanCache() {
        guard shouldAutoCleanCache else {
            return
        }
        
        for (url, expirationDate) in expirationDates {
            if expirationDate < Date() {
                removeDataFromCache(for: url as URL)
            }
        }
    }
    
    @objc
    func handleAppDidEnterBackground() {
        autoCleanCache()
    }
}

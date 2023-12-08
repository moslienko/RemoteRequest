//
//  AppDelegate.swift
//  Example
//
//  Created by Pavel Moslienko on 22 авг. 2021 г..
//  Copyright © 2021 Pavel Moslienko. All rights reserved.
//

import UIKit

// MARK: - AppDelegate

/// The AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The UIWindow
    var window: UIWindow?

    /// The RootViewController
    var rootViewController: UIViewController {
        return ExampleViewController()
    }

    /// Application did finish launching with options
    ///
    /// - Parameters:
    ///   - application: The UIApplication
    ///   - launchOptions: The LaunchOptions
    /// - Returns: The launch result
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize UIWindow
        self.window = .init(frame: UIScreen.main.bounds)
        // Set RootViewController
        self.window?.rootViewController = self.rootViewController
        // Make Key and Visible
        self.window?.makeKeyAndVisible()
        // Return positive launch
        return true
    }

}

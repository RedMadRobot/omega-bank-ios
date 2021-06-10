//
//  AppDelegate.swift
//  OmegaBank
//
//  Created by Code Generator.
//  Copyright © 2020 Redmadrobot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    private lazy var appViewController = AppViewController()
    private lazy var appViewController = PinCodeCreateViewController()
//    private lazy var appViewController = PinCodeEntryViewController()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        
        return true
    }
    
    // MARK: - Private

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = appViewController
        window?.makeKeyAndVisible()
    }
}

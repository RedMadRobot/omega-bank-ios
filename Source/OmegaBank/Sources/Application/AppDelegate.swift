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

    private lazy var appViewController = AppViewController()
    private lazy var logoutScheduler: WorkScheduler = WorkDispathScheduler()
    
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logoutScheduler.async(after: 10, execute: { [weak self] in
            self?.appViewController.showPinCode()
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logoutScheduler.cancel()
    }
}

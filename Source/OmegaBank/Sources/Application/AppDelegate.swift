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

    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - Private properties
    
    private lazy var appViewController = AppViewController()
    private lazy var logoutScheduler: WorkScheduler = DispatсhWorkScheduler()
    
    private var privacyProtectionWindow: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        
        return true
    }
    
    // MARK: - UIApplicationDelegate
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        showPrivacyProtectionWindow()
        logoutScheduler.async(after: 10) { [weak self] in
            self?.appViewController.showPinCode()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        hidePrivacyProtectionWindow()
        logoutScheduler.cancel()
    }
    
    func showPrivacyProtectionWindow() {
        privacyProtectionWindow = UIWindow(frame: UIScreen.main.bounds)
        privacyProtectionWindow?.rootViewController = PrivacyProtectionViewController()
        privacyProtectionWindow?.windowLevel = .alert + 1
        privacyProtectionWindow?.makeKeyAndVisible()
    }
    
    // MARK: - Private methods

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = appViewController
        window?.makeKeyAndVisible()
    }
    
    private func hidePrivacyProtectionWindow() {
        privacyProtectionWindow?.isHidden = true
        privacyProtectionWindow = nil
    }
}

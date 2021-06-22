//
//  AppViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 06.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Корневой контроллер всего приложения.
final class AppViewController: UITabBarController {

    private let loginService: LoginService
    private var isAuthorized: Bool { loginService.isAuthorized }
    private var isAuthenticationCompleted = false

    init(
        loginService: LoginService = ServiceLayer.shared.loginService) {
        self.loginService = loginService

        super.init(nibName: nil, bundle: nil)
        
        setupTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        showContent()
        delegate = self
    }
    
    // MARK: - Public Methods
    
    func showPinCode() {
        guard isAuthenticationCompleted else { return }
        isAuthenticationCompleted = false
        
        showEntryPinCode()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        tabBar.barTintColor = .makeGradient(from: .bar1, to: .bar2, on: tabBar.bounds)
        tabBar.tintColor = .textPrimary
        tabBar.isHidden = true
    }

    private func show(_ viewControllers: [UIViewController], animated: Bool = true) {
        setViewControllers(viewControllers, animated: animated)
    }

    private func showLogin(animated: Bool = true) {
        isAuthenticationCompleted = false
        
        tabBar.isHidden = true
        
        let controller = LoginViewController(loginService: loginService)
        let nc = NavigationController(rootViewController: controller)
        controller.delegate = self

        show([nc], animated: animated)
    }

    private func showMain(animated: Bool = true) {
        isAuthenticationCompleted = true
        
        tabBar.isHidden = false
        
        let productList = MainProductListContainerViewController.make(delegate: self)
        let partnerList = PartnerListContainerViewController.make(delegate: self)

        let tabBarViewControllers = [
            productList,
            partnerList
        ]

        show(tabBarViewControllers, animated: animated)
    }
    
    private func showCreatePinCode(animated: Bool = true) {
        tabBar.isHidden = true
        
        let controller = PinCodeCreateViewController(loginService: loginService)
        let nc = NavigationController(rootViewController: controller)
        controller.delegate = self
        
        show([nc], animated: animated)
    }
    
    private func showEntryPinCode(animated: Bool = true) {
        tabBar.isHidden = true
        
        let controller = PinCodeEntryViewController(loginService: loginService)
        let nc = NavigationController(rootViewController: controller)
        
        controller.delegate = self
        
        show([nc], animated: animated)
    }

    private func showContent(animated: Bool = true) {
        if isAuthorized {
            showEntryPinCode(animated: false)
        } else {
            showLogin(animated: animated)
        }
    }
    
    private func logOut() {
        loginService.logOut()
        showLogin(animated: true)
        isAuthenticationCompleted = false
    }
}

// MARK: - LoginViewControllerDelegate

extension AppViewController: LoginViewControllerDelegate {
    
    func loginViewControllerDidAuth(_ controller: LoginViewController) {
        showCreatePinCode(animated: true)
    }
}

// MARK: - PinCodeCreateViewControllerDelegate

extension AppViewController: PinCodeCreateViewControllerDelegate {
    
    func pinCodeCreateViewControllerDidMake(_ controller: PinCodeCreateViewController) {
        showMain(animated: true)
    }
}

// MARK: - PinCodeEntryViewControllerDelegate

extension AppViewController: PinCodeEntryViewControllerDelegate {
    
    func pinCodeEntryViewControllerEntered(_ controller: PinCodeEntryViewController) {
        showMain(animated: true)
    }
    
    func pinCodeEntryViewControllerDidLogout(_ controller: PinCodeEntryViewController) {
        logOut()
    }
    
}

// MARK: - ProfileViewControllerDelegate

extension AppViewController: ProfileViewControllerDelegate {

    func mainViewControllerDidLogout() {
        logOut()
    }
}

// MARK: - UITabBarControllerDelegate

extension AppViewController: UITabBarControllerDelegate {

    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        FadeTransition.makeAnimator()
    }
}

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

    // MARK: - Private Methods
    
    private func setupTabBar() {
        tabBar.barTintColor = .makeGradient(from: .bar1, to: .bar2, on: tabBar.bounds)
        tabBar.tintColor = .textPrimary
    }

    private func show(_ viewControllers: [UIViewController], animated: Bool = true) {
        setViewControllers(viewControllers, animated: animated)
    }

    private func showLogin(animated: Bool = true) {
        tabBar.isHidden = true
        
        let controller = LoginViewController(loginService: loginService)
        let nc = NavigationController(rootViewController: controller)
        controller.delegate = self

        show([nc], animated: animated)
    }

    private func showMain(animated: Bool = true) {
        if tabBar.isHidden {
            tabBar.isHidden = false
        }
        
        let productList = MainProductListContainerViewController.make(delegate: self)
        let partnerList = PartnerListContainerViewController.make(delegate: self)

        let tabBarViewControllers = [
            productList,
            partnerList
        ]

        show(tabBarViewControllers, animated: animated)
    }
    
    private func showCreatePinCode() {
        tabBar.isHidden = true
        
        let controller = PinCodeCreateViewController()
        let nc = NavigationController(rootViewController: controller)
        controller.delegate = self
        
        show([nc], animated: true)
    }

    private func showContent(animated: Bool = true) {
        if isAuthorized {
            showMain(animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
}

// MARK: - LoginViewControllerDelegate

extension AppViewController: LoginViewControllerDelegate {

    func loginViewControllerDidAuth(_ controller: LoginViewController) {
        showCreatePinCode()
    }
}

// MARK: - PinCodeCreateViewControllerDelegate
extension AppViewController: PinCodeCreateViewControllerDelegate {
    
    func pinCodeCreateViewControllerDidMake(_ controller: PinCodeCreateViewController) {
        showMain(animated: true)
    }
}

// MARK: - ProfileViewControllerDelegate

extension AppViewController: ProfileViewControllerDelegate {

    func mainViewControllerDidLogout() {
        showLogin(animated: true)
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

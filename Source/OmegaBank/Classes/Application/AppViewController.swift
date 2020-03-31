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
    }

    // MARK: - Private
    
    private func setupTabBar() {
        tabBar.barTintColor = UIColor.makeGradient(from: .bar1, to: .bar2, on: tabBar.bounds)
        tabBar.tintColor = .textPrimary
    }

    private func show(_ vc: UIViewController, animated: Bool = true) {
        setViewControllers([vc], animated: animated)
    }

    private func showLogin(animated: Bool = true) {
        let controller = LoginViewController(loginService: loginService)
        let nc = NavigationController(rootViewController: controller)
        controller.delegate = self

        show(nc, animated: animated)
    }

    private func showMain(animated: Bool = true) {
        let controller = PartnerListViewController()
        let navigationController = NavigationController(rootViewController: controller)
        controller.delegate = self
        controller.tabBarItem = UITabBarItem(title: "Partners", image: #imageLiteral(resourceName: "customers"), tag: 0)

        show(navigationController, animated: animated)
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
        showMain(animated: true)
    }
}

// MARK: - MainViewControllerDelegate

extension AppViewController: MainViewControllerDelegate {

    func mainViewControllerDidLogout() {
        showLogin(animated: true)
    }
}

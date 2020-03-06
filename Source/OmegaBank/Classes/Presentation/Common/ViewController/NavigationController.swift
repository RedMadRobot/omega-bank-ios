//
//  NavigationController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Элемент навигации.
protocol NavigationUnit {

    /// Скрыт ли навигейшн бар.
    var isNavigationBarHidden: Bool { get }
}

/// Кастомный NavigationController приложения
final class NavigationController: UINavigationController {

    /// Текущий вью контроллер.
    private var viewController: UIViewController? { topViewController }

    // MARK: - UIViewController

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        navigationBar.barStyle = .default
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .textPrimary
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = .bar

        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.body1,
            NSAttributedString.Key.foregroundColor: UIColor.textPrimary
        ]
    }

    // MARK: - UIViewController (UIViewControllerRotation)

    override var shouldAutorotate: Bool {
        viewController?.shouldAutorotate ?? false
    }

    // MARK: - UINavigationController

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        hideBackButtonTitle(for: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - UIContentContainer

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let controller = viewController else { return }

        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) in
            self.updateNavigationBar(for: controller, animated: context.isAnimated)
        }, completion: { (context: UIViewControllerTransitionCoordinatorContext) in
            guard context.isCancelled else { return }
            self.updateNavigationBar(for: controller, animated: context.isAnimated)
        })
    }

    // MARK: - Private

    private func hideBackButtonTitle(for viewController: UIViewController) {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.accessibilityIdentifier = "back"
        viewController.navigationItem.backBarButtonItem = backBarButtonItem
    }

    private func updateNavigationBar(for viewController: UIViewController, animated: Bool) {
        let hidden = (viewController as? NavigationUnit)?.isNavigationBarHidden ?? false
        guard hidden != isNavigationBarHidden else { return }
        setNavigationBarHidden(hidden, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate

extension NavigationController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool) {

        hideBackButtonTitle(for: viewController)
        updateNavigationBar(for: viewController, animated: animated)
    }

    func navigationControllerSupportedInterfaceOrientations(
        _ navigationController: UINavigationController) -> UIInterfaceOrientationMask {

        viewController?.supportedInterfaceOrientations ?? .portrait
    }

    func navigationControllerPreferredInterfaceOrientationForPresentation(
        _ navigationController: UINavigationController) -> UIInterfaceOrientation {

        viewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}

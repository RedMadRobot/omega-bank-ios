//
//  UIViewController+Child.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/9/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIViewController {

    func addChildViewController(_ child: UIViewController, to container: UIView) {
        addChild(child)
        container.addSubview(child.view, with: container)
        child.didMove(toParent: self)
    }

    /// Добавить дочерний контроллер вместе с его `view` и активировать констрейнты.
    ///
    /// - Parameters:
    ///   - child: Дочерний контроллер.
    ///   - constraints: Констрейнты `view` дочернего контроллера.
    func addChildViewController(
        _ child: UIViewController,
        activate constraints: @autoclosure () -> [NSLayoutConstraint]) {

        addChild(child)
        view.addSubview(child.view, activate: constraints())
        child.didMove(toParent: self)
    }

    /// Удалить из родительского контроллера.
    func removeChildFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

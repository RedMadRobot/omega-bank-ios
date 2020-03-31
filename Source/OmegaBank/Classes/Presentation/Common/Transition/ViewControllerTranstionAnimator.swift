//
//  ViewControllerTranstionAnimator.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/30/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Базовый аниматор переходов между `UIViewController`.
class ViewControllerTranstionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    /// Продолжительность анимации.
    private let duration: TimeInterval

    /// Создать новго аниматора переходов.
    ///
    /// - Parameter duration: Продолжительность анимации.
    init(duration: TimeInterval) {
        self.duration = duration
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("\(#function) has not been implemented")
    }
}

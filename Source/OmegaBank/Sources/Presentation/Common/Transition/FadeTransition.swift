//
//  FadeTransition.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/30/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Переход с затуханием.
final class FadeTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    private enum Constants {
        static let duration: TimeInterval = 0.3
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        FadePresentingAnimator(duration: Constants.duration)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FadeDismissingAnimator(duration: Constants.duration)
    }
    
    static func makeAnimator() -> ViewControllerTransitionAnimator {
        FadePresentingAnimator(duration: Constants.duration)
    }
}

private final class FadePresentingAnimator: ViewControllerTransitionAnimator {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView, with: containerView)
        toView.alpha = 0

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseIn,
            animations: {
                toView.alpha = 1
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(success)
            })
    }
}

private final class FadeDismissingAnimator: ViewControllerTransitionAnimator {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseIn,
            animations: {
                fromView.alpha = 0
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(success)
            })
    }
}

//
//  AppearingViewAnimation.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

typealias AppearingViewAnimation = (UIView, Int) -> Void

final class AppearingViewAnimator {
    
    // MARK: - Private Properties
    
    private let animation: AppearingViewAnimation

    // MARK: - Initialization
    
    init(animation: @escaping AppearingViewAnimation) {
        self.animation = animation
    }
    
    // MARK: - Public Methods
    
    static func makeMove(
        startOrigin: CGPoint,
        duration: TimeInterval,
        delay: Double) -> AppearingViewAnimation { { view, index in
        view.transform = CGAffineTransform(translationX: startOrigin.x, y: startOrigin.y)
        
        UIView.animate(
            withDuration: duration,
            delay: delay * Double(index),
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.1,
            options: .curveEaseInOut,
            animations: { view.transform = CGAffineTransform(translationX: 0, y: 0) })
        }
    }

    func animate(cell: UIView, index: Int) {
        animation(cell, index)
    }
}

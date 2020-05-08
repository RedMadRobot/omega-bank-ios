//
//  AppearingViewAnimator.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class AppearingViewAnimator {
    
    // MARK: - Types
    
    typealias Animation = (_ view: UIView, _ index: Int, _ delay: Double?) -> Void
    
    // MARK: - Constants
    
    private enum Constants {

        /// Длительность полной анимации появления экрана.
        static let fullAppearingDuration = 1.0
        /// Длительность полной анимации одного элемента. Должно быть меньше, чем fullAppearingDuration
        static let oneItemAppearingDuration = 0.5
        
    }
    
    // MARK: - Private Properties
    
    private let animation: Animation

    // MARK: - Initialization
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    // MARK: - Public Methods
    
    static func makeMove(startOrigin: CGPoint, count: Int) -> Animation {
        return { view, index, delay in
            
            view.transform = CGAffineTransform(translationX: startOrigin.x, y: startOrigin.y)
            view.alpha = 0
            let itemDelay = oneItemDelay(count: count)
            
            UIView.animate(
                withDuration: Constants.oneItemAppearingDuration,
                delay: itemDelay * Double(index) + (delay ?? 0.0),
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0.1,
                options: .curveEaseInOut,
                animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: 0)
                    view.alpha = 1
                })
        }
    }
    
    static func makeHide(count: Int) -> Animation {
        return { view, index, delay in
            let itemDelay = oneItemDelay(count: count)
            
            UIView.animate(
                withDuration: Constants.oneItemAppearingDuration,
                delay: itemDelay * Double(index) + (delay ?? 0.0),
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: .curveEaseInOut,
                animations: {
                    toggleAlpha(view)
                    view.isHidden.toggle()
                })
        }
    }

    func animate(cell: UIView, index: Int = 0, delay: Double? = 0) {
        animation(cell, index, delay)
    }
    
    // MARK: - Private Methods
    
    private static func oneItemDelay(count: Int) -> Double {
        let fullDuration = Constants.fullAppearingDuration
        let oneItemDuration = Constants.oneItemAppearingDuration
        let oneItemDelay = (fullDuration - oneItemDuration) / Double(count)
        
        return oneItemDelay
    }
    
    private static func toggleAlpha(_ view: UIView) {
        view.alpha = 1 - view.alpha
    }
}

//
//  PinCodeIndicatorView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

// MARK: - Types

enum ClearAnimation {
    case shakeAndPop
    case push
}

final class PinCodeIndicatorView: UIView, NibLoadable {
    
    // MARK: - Private types
    
    enum AnimationConstants {
        static let clearPushDuration = 0.2
        
        static let clearShakeDelay = 0.0
        static let clearShakeDuration = 0.4
        static let clearShakeSpringWithDamping: CGFloat = 0.2
        static let clearShakeInitialSpringVelocity: CGFloat = 0.2
    }
    
    // MARK: - Public Properties
    
    var value: Int = 0 {
        didSet {
            for view in indicatorViews { view.backgroundColor = view.tag < value ? .bar2 : .cellBorder }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private var indicatorViews: [UIView]!
    
    // MARK: - Public methods
    
    func showError() { indicatorViews.forEach { $0.backgroundColor = .red } }
    
    func clear(with animation: ClearAnimation, completion: VoidClosure?) {
        switch animation {
        case .push:
            clear(completion)
        case .shakeAndPop:
            clearWithShake(completion)
        }
    }
    
    // MARK: - Private methods
    
    private func clear() { indicatorViews.forEach { $0.backgroundColor = .cellBorder } }
    
    private func clear(_ completion: VoidClosure?) {
        let width = frame.width
        UIView.animate(withDuration: AnimationConstants.clearPushDuration, animations: {
            self.transform = self.transform.translatedBy(x: width, y: 0)
        }, completion: { _ in
            self.transform = CGAffineTransform(translationX: width, y: 0)
            self.clear()
            UIView.animate(
                withDuration: AnimationConstants.clearPushDuration,
                animations: { self.transform = .identity },
                completion: { _ in completion?() })
        })
    }
    
    private func clearWithShake(_ completion: VoidClosure?) {
        transform = CGAffineTransform(translationX: 40, y: 0)
        UIView.animate(
            withDuration: AnimationConstants.clearShakeDuration,
            delay: AnimationConstants.clearShakeDelay,
            usingSpringWithDamping: AnimationConstants.clearShakeSpringWithDamping,
            initialSpringVelocity: AnimationConstants.clearShakeInitialSpringVelocity,
            options: .curveEaseIn,
            animations: { self.transform = .identity },
            completion: { _ in
                self.clear()
                completion?()
            })
    }
}

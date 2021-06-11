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
    
    // MARK: - Public Properties
    
    var value: Int = 0 {
        didSet {
            for (index, view) in indicatorViews.enumerated() {
                view.backgroundColor = index < value ? .bar2 : .cellBorder
            }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private var indicatorViews: [UIView]!
    
    // MARK: - Public methods
    
    func showError() { indicatorViews.forEach { $0.backgroundColor = .red } }
    
    func clear(with animation: ClearAnimation, completion: (() -> Void)?) {
        switch animation {
        case .push:
            clear(completion: completion)
        case .shakeAndPop:
            clear(completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func clear() { indicatorViews.forEach { $0.backgroundColor = .cellBorder } }
    
    private func clear(completion: (() -> Void)?) {
        let width = frame.width
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = self.transform.translatedBy(x: width, y: 0)
        }, completion: { _ in
            self.transform = CGAffineTransform(translationX: width, y: 0)
            self.clear()
            UIView.animate(
                withDuration: 0.2,
                animations: { self.transform = .identity },
                completion: { _ in completion?() })
        })
    }
    
    private func clearWithShake(_ completion: (() -> Void)?) {
        transform = CGAffineTransform(translationX: 40, y: 0)
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: { self.transform = .identity },
            completion: { _ in
                self.clear()
                completion?()
            })
    }
}

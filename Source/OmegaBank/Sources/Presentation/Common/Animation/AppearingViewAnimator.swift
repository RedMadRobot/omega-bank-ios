//
//  AppearingViewAnimator.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

// MARK: - Types

typealias AppearingAnimation = (
    _ view: UIView,
    _ index: Int,
    _ count: Int,
    _ transform: @escaping AnimationTransform) -> Void

typealias AnimationTransform = (_ view: UIView) -> Void
typealias AnimationToggleTransform = (_ view: UIView, _ isCollapsed: Bool) -> Void

struct AnimatorConfiguration {
    
    /// Подготовка к анимации. Размеры `View` пока неопределены.
    var initialState: AnimationTransform?
    
    /// Положение `View` в начале анимации. Можно опираться на размеры  и положение `View`.
    var startState: AnimationTransform?
    
    /// Положение `View` в конце анимации. Можно опираться на размеры и положение `View`.
    var endState: AnimationTransform
}

final class AppearingViewAnimator {

    // MARK: - Constants
    
    private enum Constants {

        /// Длительность полной анимации появления экрана.
        static let fullAppearingDuration = 1.0
        /// Длительность полной анимации одного элемента. Должно быть меньше, чем fullAppearingDuration
        static let oneItemAppearingDuration = 0.5
        
    }
    
    // MARK: - Public Properties
    
    let configuration: AnimatorConfiguration
    
    // MARK: - Initialization

    init(configuration: AnimatorConfiguration) {
        self.configuration = configuration
    }

    // MARK: - Public Methods
    
    /// Применяем заданную анимацию к `View`
    /// элементу с задержкой равной индексу элемента.
    func animate(
        view: UIView,
        isCollapsed: Bool,
        index: Int = 0,
        count: Int = 0) {
        
        let itemDelay = oneItemDelay(count: count)

        UIView.animate(
            withDuration: Constants.oneItemAppearingDuration,
            delay: itemDelay * Double(index),
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                if isCollapsed {
                    self.configuration.startState?(view)
                } else {
                    self.configuration.endState(view)
                }
            })
    }
    
    /// Подготавливаем `View` к анимации. Размеры
    /// и положение`View`пока неизвестно.
    func setInitialState(view: UIView) {
        configuration.initialState?(view)
    }
    
    /// Выставляем начальное положение `View`
    /// перед анимацией. Размеры и положение `View` известны.
    func setStartState(view: UIView) {
        configuration.startState?(view)
    }
    
    // MARK: - Private Methods
    
    /// Расчет задержки на один элемент из учета полного времени анимации
    /// в расчете на общее колличество элементов `count`.
    private func oneItemDelay(count: Int) -> Double {
        let fullDuration = Constants.fullAppearingDuration
        let oneItemDuration = Constants.oneItemAppearingDuration
        let oneItemDelay = (fullDuration - oneItemDuration) / Double(count)
        
        return oneItemDelay
    }

}

extension AppearingViewAnimator {
    
    static var downToUp: AppearingViewAnimator {
        let configuration = AnimatorConfiguration(
            initialState: { view in
                view.isHidden = true
                view.alpha = 0
            },
            startState: { view in
                view.isHidden = true
                view.alpha = 0
            },
            endState: { view in
                view.isHidden = false
                view.alpha = 1
            })
        
        return AppearingViewAnimator(configuration: configuration)
    }
    
    static func makeRightToLeft(stackView: UIStackView) -> AppearingViewAnimator {
        let configuration = AnimatorConfiguration(
            initialState: { view in
                view.alpha = 0
            },
            startState: { [unowned stackView] view in
                view.alpha = 0
                view.transform = CGAffineTransform(translationX: stackView.frame.width, y: .zero)
            },
            endState: { view in
                view.alpha = 1
                view.transform = CGAffineTransform(translationX: .zero, y: .zero)
            }
        )
        
        return AppearingViewAnimator(configuration: configuration)
    }
}

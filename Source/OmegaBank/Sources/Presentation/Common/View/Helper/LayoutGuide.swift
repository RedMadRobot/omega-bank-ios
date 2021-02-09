//
//  LayoutGuide.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/30/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Обобщенный тип лайаут гайда.
///
/// - Note: Обобщение `UIView` и `UILayoutGuide`.
public protocol LayoutGuide {
    /// Верхний край.
    var topAnchor: NSLayoutYAxisAnchor { get }
    /// Нижний край.
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    /// Правый край.
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    /// Левый край.
    var leadingAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}

extension UIView {

    /// Добавить сабвью вместе с лайаут гайдом.
    /// ```
    /// final class TextCell: UICollectionViewCell {
    ///     let textLabel = UILabel()
    ///
    ///     override init(frame: CGRect) {
    ///         super.init(frame: frame)
    ///         addSubview(textLabel, with: layoutMarginsGuide)
    ///         // addSubview(textLabel, with: self)
    ///     }
    /// }
    /// ```
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - guide: Гайд, к краям которого будет крепиться вью.
    func addSubview(_ subview: UIView, with guide: LayoutGuide) {
        assert((guide as? UIView) != subview, "Края сабвью не могут быть привазаны к ней же")
        addSubview(subview, activate: [
            subview.topAnchor.constraint(equalTo: guide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            subview.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        ])
    }

    /// Добавить сабвью и активировать констрейнты.
    ///
    /// - Parameters:
    ///   - subview: Сабвью.
    ///   - constraints: Констрейнты создаются из замыкания после, того как `subview` будет добавлена.
    func addSubview(_ subview: UIView, activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate(constraints())
    }

    /// Добавляет сабвьюшки и активирует у них констрейнты.
    /// Для добавления нескольких сабвью рекомендуется использовать этот метод т.к. активация констрейнтов вызывается сразу для всех вью, что работает быстрее чем если активировать отдельно каждый констрейнт.
    ///
    /// - Parameters:
    ///   - subviews: Сабвьюшки
    ///   - constraints: Констрейнты создаются из замыкания после, того как все `subview` будут добавлены.
    func addSubviews(_ subviews: [UIView], activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        NSLayoutConstraint.activate(constraints())
    }
}

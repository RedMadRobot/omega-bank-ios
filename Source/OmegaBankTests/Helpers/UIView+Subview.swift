//
//  UIView+Subview.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/1/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import XCTest

/// Методы для доступа к `subview` для тестирования.
extension UIView {

    func subview<T>(_ type: T.Type, by accessibilityIdentifier: String? = nil) -> T? where T: UIView {
        for subview in subviews {
            guard let view = subview as? T else { continue }
            guard let id = accessibilityIdentifier else {
                return view
            }
            if view.accessibilityIdentifier == id {
                return view
            }
        }
        for subview in subviews {
            if let view = subview.subview(type, by: accessibilityIdentifier) {
                return view
            }
        }
        return nil
    }

    func allSubviews<T>(_ type: T.Type, by accessibilityIdentifier: String) -> [T] where T: UIView {
        var result = [T]()
        var nodeQueue = subviews
        while nodeQueue.isEmpty == false {
            let node = nodeQueue.remove(at: 0)
            if let view = node as? T, view.accessibilityIdentifier == accessibilityIdentifier {
                result.append(view)
            } else {
                if node.subviews.isEmpty == false {
                    nodeQueue.append(contentsOf: node.subviews)
                }
            }
        }
        return result
    }

    func label(by accessibilityIdentifier: String, file: StaticString = #file, line: UInt = #line) -> UILabel? {
        let label = subview(UILabel.self, by: accessibilityIdentifier)
        XCTAssertNotNil(button, "\(accessibilityIdentifier) label not found", file: file, line: line)
        return label
    }

    func button(by accessibilityIdentifier: String, file: StaticString = #file, line: UInt = #line) -> UIButton? {
        let button = subview(UIButton.self, by: accessibilityIdentifier)
        XCTAssertNotNil(button, "\(accessibilityIdentifier) button not found", file: file, line: line)
        return button
    }

    /// Получение доступа к `subview`.
    ///
    /// - Parameters:
    ///   - type: Тип искомой `subview`.
    ///   - accessibilityIdentifier: Идентификатор искомой `subview`.
    /// - Returns: Найденая `subview`, либо `nil`.
    @discardableResult
    func assertSubview<T>(
        _ type: T.Type,
        by accessibilityIdentifier: String,
        file: StaticString = #file,
        line: UInt = #line) -> T? where T: UIView {

        let view = subview(type, by: accessibilityIdentifier)

        XCTAssertNotNil(view, "Not found \(T.self) \(accessibilityIdentifier)", file: file, line: line)

        return view
    }
}

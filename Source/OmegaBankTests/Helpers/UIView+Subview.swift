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
        let typedSubviews = subviews.compactMap { $0 as? T }
        
        guard let id = accessibilityIdentifier else { return typedSubviews.first }
        guard let typedSubview = typedSubviews.first(where: { $0.accessibilityIdentifier == id }) else {
            return subviews
                .compactMap { $0.subview(type, by: accessibilityIdentifier) }
                .first
        }
        
        return typedSubview
    }
    
    func allSubviews<T>(_ type: T.Type, by accessibilityIdentifier: String? = nil) -> [T] where T: UIView {
        var result = [T]()
        var nodeQueue = subviews
        while nodeQueue.isEmpty == false {
            let node = nodeQueue.remove(at: 0)
            if let view = node as? T {
                if let ident = accessibilityIdentifier, view.accessibilityIdentifier == ident
                    || accessibilityIdentifier == nil {
                    result.append(view)
                }
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
    
    func textField(by accessibilityIdentifier: String, file: StaticString = #file, line: UInt = #line) -> UITextField? {
        let textField = subview(UITextField.self, by: accessibilityIdentifier)
        XCTAssertNotNil(textField, "\(accessibilityIdentifier) textField not found", file: file, line: line)
        return textField
    }
    
    func textView(by accessibilityIdentifier: String, file: StaticString = #file, line: UInt = #line) -> UITextView? {
        let textView = subview(UITextView.self, by: accessibilityIdentifier)
        XCTAssertNotNil(textView, "\(accessibilityIdentifier) textView not found", file: file, line: line)
        return textView
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

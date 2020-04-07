//
//  UIViewController+UIBarButtonItem.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/1/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import XCTest

extension UIViewController {
    
    /// Доступ к `UIBarButtonItem` для тестирования.
    @discardableResult
    func assertBarButtonItem(
        by accessibilityLabel: String,
        file: StaticString = #file,
        line: UInt = #line) -> UIBarButtonItem? {

        var barButtonItem: UIBarButtonItem?
        
        switch accessibilityLabel {
        case navigationItem.rightBarButtonItem?.accessibilityLabel:
            barButtonItem = navigationItem.rightBarButtonItem
        case navigationItem.leftBarButtonItem?.accessibilityLabel:
            barButtonItem = navigationItem.rightBarButtonItem
        default:
            break
        }
        
        XCTAssertNotNil(
            barButtonItem,
            "Not found \(UIBarButtonItem.self) \(accessibilityLabel)",
            file: file,
            line: line)
        
        return barButtonItem
    }

}

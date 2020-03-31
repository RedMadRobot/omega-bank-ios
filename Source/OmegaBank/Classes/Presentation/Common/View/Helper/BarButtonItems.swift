//
//  BarButtonItems.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 26.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// Назад.
    static func back(target: Any, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: target,
            action: action)
        
        item.accessibilityIdentifier = "back"
        item.accessibilityLabel = "Назад"
        
        return item
    }
    
    /// Дальше.
    static func next(target: Any, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: target,
            action: action)
        
        item.accessibilityIdentifier = "next"
        item.accessibilityLabel = "Дальше"
        
        return item
    }
}

//
//  UIStackView+Subviews.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 8/19/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func arrangedSubview<T>(_ type: T.Type, by accessibilityIdentifier: String? = nil) -> T? where T: UIView {
        let result = arrangedSubviews
            .compactMap { $0 as? T }
        guard let ident = accessibilityIdentifier else { return result.first }
        
        return result.first(where: { $0.accessibilityIdentifier == ident })
    }
    
    func arrangedSubviews<T>(_ type: T.Type, by accessibilityIdentifier: String? = nil) -> [T] where T: UIView {
        let result = arrangedSubviews
            .compactMap { $0 as? T }
        guard let ident = accessibilityIdentifier else { return result }
        
        return result.filter { $0.accessibilityIdentifier == ident }
    }
    
}

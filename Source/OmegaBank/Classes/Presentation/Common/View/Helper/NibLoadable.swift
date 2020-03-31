//
//  NibLoadable.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol NibLoadable: NibRepresentable {}

extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        let results: [Any] = nib.instantiate(withOwner: self, options: nil)
        for result in results {
            if let view = result as? Self {
                return view
            }
        }
        fatalError("\(self) not found")
    }
}

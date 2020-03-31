//
//  NibRepresentable.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol NibRepresentable: AnyObject {

    static var className: String { get }

    static var nib: UINib { get }
}

extension NibRepresentable {

    static var className: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: className, bundle: nil)
    }
}

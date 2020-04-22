//
//  Timeout.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import XCTest

// MARK: - Types

enum Timeout: Double {
    case minimum = 0.66
    case medium = 1
    case maximum = 5
    case extra = 10
    case zero = 0
    
    var timeInterval: TimeInterval { rawValue }
}

//
//  BoolStorage.swift
//  OmegaBank
//
//  Created by Alexander Ignatev on 20/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

public protocol BoolStorage: AnyObject {

    func set(_ value: Bool, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
}

extension UserDefaults: BoolStorage {}

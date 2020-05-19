//
//  Card.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/12/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

public struct Card: Decodable {

    public var name: String
    public var number: String
    public var value: Double
    
    // MARK: - Initialization
    
    public init(name: String, number: String, value: Double) {
        self.name = name
        self.number = number
        self.value = value
    }
}

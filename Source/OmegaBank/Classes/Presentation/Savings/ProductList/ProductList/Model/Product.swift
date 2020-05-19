//
//  Product.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit

protocol Product {
    var name: String { get }
    var number: String { get }
    var value: Double { get }
}

extension Card: Product { }

extension Deposit: Product { }

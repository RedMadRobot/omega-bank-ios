//
//  UserProduct.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 5/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit

enum UserProduct: Product {

    case card(Card)
    case deposit(Deposit)
    
    var name: String {
        switch self {
        case .card(let card):
            return card.name
        case .deposit(let deposit):
            return deposit.name
        }
    }
    
    var number: String {
        switch self {
        case .card(let card):
            return card.number
        case .deposit(let deposit):
            return deposit.number
        }
    }
    
    var value: Double {
        switch self {
        case .card(let card):
            return card.value
        case .deposit(let deposit):
            return deposit.value
        }
    }

}

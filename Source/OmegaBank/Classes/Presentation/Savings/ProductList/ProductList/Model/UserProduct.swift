//
//  UserProduct.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

protocol Product {
    var name: String { get }
    var number: String { get }
    var value: Double { get }
}

struct Card: Product {
    var name: String
    var number: String
    var value: Double
}

struct Deposit: Product {
    var name: String
    var number: String
    var value: Double
}

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

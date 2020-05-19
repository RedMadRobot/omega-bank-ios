//
//  ProductType.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

enum ProductType: CaseIterable {
    case card
    case deposit
    
    var title: String {
        switch self {
        case .card:
            return "Deposit cards"
        case .deposit:
            return "Bank Accouts"
        }
    }
}

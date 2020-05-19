//
//  SavingMock.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 5/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBankAPI

protocol SavingMock {}

extension SavingMock {
    
    func makeCard(
        name: String = "Visa Classic",
        number: String = "NNNN RRRR 999 9999 99",
        value: Double = 1_111) -> Card {
        
        Card(
            name: name,
            number: number,
            value: value)
    }
    
    func makeDeposit(
        name: String = "Visa Classic",
        number: String = "GGGG MMMM 888 8888 88",
        value: Double = 99_999) -> Deposit {
        
        Deposit(
            name: name,
            number: number,
            value: value)
    }
    
}

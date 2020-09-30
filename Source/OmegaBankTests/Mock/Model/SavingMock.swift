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
        name: String = "Platinum",
        number: String = "GGGG MMMM 888 8888 88",
        value: Double = 99_999) -> Deposit {
        
        Deposit(
            name: name,
            number: number,
            value: value)
    }

    func makeCardInfo(
        code: String = "card",
        name: String = "Card",
        about: [ProductDescriptor] = [
            ProductDescriptor(caption: "Card Caption 1", value: "Card Value 1"),
            ProductDescriptor(caption: "Card Caption 2", value: "Card Value 2"),
            ProductDescriptor(caption: "Card Caption 3", value: "Card Value 3") ]) -> CardInfo {
        CardInfo(code: code, name: name, about: about)
    }
    
    func makeDepositInfo(
        code: String = "deposit",
        name: String = "Deposit",
        description: String = "Deposit Description",
        about: [ProductDescriptor] = [
            ProductDescriptor(caption: "Deposit Caption 1", value: "Deposit Value 1"),
            ProductDescriptor(caption: "Deposit Caption 2", value: "Deposit Value 2"),
            ProductDescriptor(caption: "Deposit Caption 3", value: "Deposit Value 3") ]) -> DepositInfo {
        DepositInfo(code: code, name: name, description: description, about: about)
    }
}

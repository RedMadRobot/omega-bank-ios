//
//  PartnerMock.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBankAPI

protocol PartnerMock {}

extension PartnerMock {
    
    func makeCurrency(
        name: String = "RUB") -> Currency {
        
        Currency(name: name)
    }
    
    func makeDailylimit(
        currency: Currency,
        amout: Int = 5) -> DailyLimit {
        
        DailyLimit(currency: currency, amount: amout)
    }
    
    func makeLimit(
        currency: Currency,
        min: UInt? = 0,
        max: UInt? = 5) -> Limit {
        
        Limit(currency: currency, min: min, max: max)
    }
    
    func makePartner(
        name: String = "Partner 1",
        picture: URL = URL(string: "https://mypic.com/1")!,
        depositionDuration: String = "1",
        limitations: String = "limitations",
        description: String = "description",
        pointType: String = "pointType",
        moneyMin: Int = 0,
        moneyMax: Int = 1,
        limits: [Limit] = [],
        dailyLimits: [DailyLimit] = []) -> Partner {
        
        Partner(
            name: name,
            picture: picture,
            depositionDuration: depositionDuration,
            limitations: limitations,
            description: description,
            pointType: pointType,
            moneyMin: moneyMin,
            moneyMax: moneyMax,
            limits: limits,
            dailyLimits: dailyLimits)
    }
}

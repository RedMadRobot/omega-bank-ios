//
//  Partner.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 06.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

/// Дебетовый партнер банка.
public struct Partner: Decodable {
    public let name: String
    public let picture: URL?
    public let depositionDuration: String
    public let limitations: String
    public let description: String
    public let pointType: String
    public let moneyMin: Int
    public let moneyMax: Int
    public let limits: [Limit]
    public let dailyLimits: [DailyLimit]
}

public struct Currency: Decodable {
    public let name: String
}

public struct Limit: Decodable {
    public let currency: Currency
    public let min: UInt?
    public let max: UInt?
}

public struct DailyLimit: Decodable {
    public let currency: Currency
    public let amount: Int?
}

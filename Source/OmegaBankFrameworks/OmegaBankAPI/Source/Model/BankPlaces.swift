//
//  BankPlaces.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

public struct BankPlaces: Decodable {
    public let offices: [BankPlace]
    public let atms: [BankPlace]
}

public struct BankPlace: Decodable {
    public let id: Int
    public let name: String?
    public let address: String?
    public let location: Location
    public let workHours: String?
    public let phone: String?
}

public struct Location: Decodable {
    public let longitude: Double
    public let latitude: Double
}

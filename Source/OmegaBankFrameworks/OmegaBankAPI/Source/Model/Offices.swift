//
//  Offices.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

public struct Office: Decodable {
    
    public let id: Int
    public let name: String?
    public let address: String?
    public let location: Location
    public let workHours: String?
    public let phone: String?
       
    // MARK: - Init
    
    public init(id: Int, name: String?, address: String?, location: Location, workHours: String?, phone: String?) {
        self.id = id
        self.name = name
        self.address = address
        self.location = location
        self.workHours = workHours
        self.phone = phone
    }
}

public struct Location: Decodable {
    
    public let longitude: Double
    public let latitude: Double
    
}

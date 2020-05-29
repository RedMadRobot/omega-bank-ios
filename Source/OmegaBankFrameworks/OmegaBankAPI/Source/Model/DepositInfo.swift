//
//  CardInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/25/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

public struct DepositInfo: Decodable {
    public let code: String
    public let name: String
    public let description: String?
    public let about: [ProductDescriptor]?
}

//
//  CardInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/25/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

public struct DepositInfo: Decodable {
    let code: String
    let name: String
    let descriptoin: String?
    let about: [ProductInfo]?
}

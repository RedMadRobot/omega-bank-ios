//
//  CardInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/25/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

public struct ProductInfo: Decodable {
    let caption: String
    let value: String
}

public struct CardInfo: Decodable {
    let code: String
    let name: String
    let about: [ProductInfo]?
}

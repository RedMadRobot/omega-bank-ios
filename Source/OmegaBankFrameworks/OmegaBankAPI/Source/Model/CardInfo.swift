//
//  CardInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/25/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

public struct ProductDescriptor: Decodable {
    public let caption: String
    public let value: String
}

public struct CardInfo: Decodable {
    public let code: String
    public let name: String
    public let about: [ProductDescriptor]?
}

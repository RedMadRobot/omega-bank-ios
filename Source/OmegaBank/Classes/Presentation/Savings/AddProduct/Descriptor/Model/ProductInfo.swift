//
//  ProductInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/27/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import struct OmegaBankAPI.CardInfo
import struct OmegaBankAPI.DepositInfo
import struct OmegaBankAPI.ProductDescriptor

protocol ProductInfo {
    var about: [ProductDescriptor]? { get }
}

extension CardInfo: ProductInfo { }

extension DepositInfo: ProductInfo { }

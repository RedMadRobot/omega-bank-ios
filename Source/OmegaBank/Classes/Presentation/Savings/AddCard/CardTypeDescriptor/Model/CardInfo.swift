//
//  CardInfo.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/30/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct CardInfo {
    
    struct CardParam {
        let key: String
        let value: String
    }
    
    let name: String
    let parameters: [CardParam]?
}

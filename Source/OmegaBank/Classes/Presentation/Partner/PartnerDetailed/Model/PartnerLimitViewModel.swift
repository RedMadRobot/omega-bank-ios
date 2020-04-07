//
//  PartnerLimitViewModel.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import struct OmegaBankAPI.Limit
import struct OmegaBankAPI.DailyLimit

struct PartnerDescriptionViewModel {
    
    let header: String
    let description: String
    
    init(header: String, description: String) {
        self.header = header
        self.description = description
    }
    
    init(limit: Limit) {
        header = limit.currency.name
        
        switch (limit.min, limit.max) {
        case (let min?, let max?):
            description = "from \(min) to \(max)"
        case (let min?, _):
            description = "from \(min)"
        case (_, let max?):
            description = "to \(max)"
        default:
            description = ""
        }
    }
    
    init(limit: DailyLimit) {
        header = limit.currency.name
        
        if let amount = limit.amount {
            description = "Amount: \(amount)"
        } else {
            description = ""
        }
    }
}

//
//  MockPartnerListService.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 3/31/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBank

final class MockPartnerListService: PartnerListService {
    
    var partnerListHandler: PartnerListHandler?
    let progress = Progress()
    
    func load(completion: @escaping PartnerListHandler) -> Progress {
        partnerListHandler = completion
        return progress
    }

}

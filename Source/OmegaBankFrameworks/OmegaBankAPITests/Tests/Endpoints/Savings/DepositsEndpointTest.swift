//
//  DepositsEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class DepositEndpointTest: XCTestCase {
    
    func testMakeRequest() throws {
        
        let endpoint = DepositsEndpoint()
        let request = try endpoint.makeRequest()
        
        assertGET(request)
        assertURL(request, "deposits")

    }
    
}

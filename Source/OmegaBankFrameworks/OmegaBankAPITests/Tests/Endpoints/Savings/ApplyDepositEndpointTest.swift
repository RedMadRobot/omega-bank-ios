//
//  ApplyDepositEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class ApplyDepositEndpointTest: XCTestCase {
    
    func testMakeRequest() throws {
        
        let endpoint = ApplyDepositEndpoint(type: "platinum")
        let request = try endpoint.makeRequest()
        
        assertPOST(request)
        assertURL(request, "deposits")
        assertJsonBody(request, [
            "type": "platinum"
        ])
        
    }

}

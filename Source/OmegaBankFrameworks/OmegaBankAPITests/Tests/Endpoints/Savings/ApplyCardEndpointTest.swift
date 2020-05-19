//
//  ApplyProductEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class ApplyCardEndpointTest: XCTestCase {
    
    func testMakeRequest() throws {
        
        let endpoint = ApplyCardEndpoint(type: "classic")
        let request = try endpoint.makeRequest()
        
        assertPOST(request)
        assertURL(request, "cards")
        assertJsonBody(request, [
            "type": "classic"
        ])

    }
    
}

//
//  PartnersEndpointTest.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/24/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class PartnersEndpointTest: XCTestCase {
    func testMakeRequest() throws {
        
        let endpoint = PartnersEndpoint()

        let request = try endpoint.makeRequest()
        
        assertGET(request)
        assertURL(request, "deposition-partners")
    }
}

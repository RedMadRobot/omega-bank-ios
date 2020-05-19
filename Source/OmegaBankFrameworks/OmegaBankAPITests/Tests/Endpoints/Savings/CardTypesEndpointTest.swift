//
//  CardTypesEndpointTests.swift
//  OmegaBankAPITests
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class CardTypesEndpointTest: XCTestCase {
    
    func testMakeRequest() throws {
        
        let endpoint = CardTypesEndpoint()
        let request = try endpoint.makeRequest()
        
        assertGET(request)
        assertURL(request, "card-types")

    }
    
}

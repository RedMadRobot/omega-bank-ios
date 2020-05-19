//
//  CardsEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class CardsEndpointTest: XCTestCase {
    
    func testMakeRequest() throws {
        
        let endpoint = CardsEndpoint()
        let request = try endpoint.makeRequest()
        
        assertGET(request)
        assertURL(request, "cards")

    }
    
}

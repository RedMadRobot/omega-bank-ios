//
//  CheckSmsCodeEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolai Zhukov on 21.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class CheckSmsCodeEndpointTest: XCTestCase {
    func testMakeRequest() throws {
        
        let endpoint = CheckSmsCodeEndpoint(
            smsCode: "1111")

        let request = try endpoint.makeRequest()
        
        assertPOST(request)
        assertURL(request, "auth/sms/check-code")
        assertJsonBody(request, [
            "sms_code": "1111"
        ])
    }
}

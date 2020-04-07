//
//  SendPhoneEndpointTest.swift
//  OmegaBankAPITests
//
//  Created by Nikolai Zhukov on 21.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import XCTest

final class SendPhoneEndpointTest: XCTestCase {
    func testMakeRequest() throws {
        
        let endpoint = SendPhoneEndpoint(phone: "\(9_999_99_99)")
        
        let request = try endpoint.makeRequest()
        
        assertPOST(request)
        assertURL(request, "auth/sms/send-code")
        assertJsonBody(request, [
            "phone_number": "\(9_999_99_99)"
        ])
    }
}

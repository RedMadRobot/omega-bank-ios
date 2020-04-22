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
        
        let endpoint = SendPhoneEndpoint(phone: "\(8_888_888_88_88)")
        
        let request = try endpoint.makeRequest()
        
        assertPOST(request)
        assertURL(request, "auth/sms/send-code")
        assertJsonBody(request, [
            "phone_number": "\(8_888_888_88_88)"
        ])
    }
}

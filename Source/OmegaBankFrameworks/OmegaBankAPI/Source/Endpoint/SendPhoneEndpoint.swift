//
//  SendPhoneEndpoint.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 18.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

/// Зарегистрировать номер телефона.
public struct SendPhoneEndpoint: EmptyEndpoint, Encodable {

    public let phoneNumber: String
    
    public init(phone: String) {
        self.phoneNumber = phone
    }

    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "auth/sms/send-code")!   
        return URLRequest.post(url, json: try encoder.encode(self))
    }
}

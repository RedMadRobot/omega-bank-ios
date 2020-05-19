//
//  CheckPhoneEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolai Zhukov on 18.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

/// Авторизация по номеру телефона.
public struct CheckSmsCodeEndpoint: JsonEndpoint, Encodable {

    public typealias Content = AuthData

    public let smsCode: String

    public init(smsCode: String) {
        self.smsCode = smsCode
    }

    func content(from root: AuthData) -> AuthData { root }

    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "auth/sms/check-code")!
        return URLRequest.post(url, json: try encoder.encode(self))
    }
}

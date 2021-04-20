//
//  SendPhoneMock.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Catbird
import Foundation

enum SendPhoneMock: String, CatbirdMockConvertible {

    case phone
    
    var url: URL { URL(string: "/auth/sms/send-code")! }
    
    var pattern: RequestPattern {
        RequestPattern(method: .POST, url: url)
    }
    
    var response: ResponseMock {
        ResponseMock(body: try? json("\(url.path)/\(rawValue)"))
    }
    
}

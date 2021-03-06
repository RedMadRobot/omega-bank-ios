//
//  SendSmsCodeMock.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/17/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Catbird
import Foundation

enum SendSmsCodeMock: String, CatbirdMockConvertible {
    
    case smsCode
    
    var url: URL { URL(string: "/auth/sms/check-code")! }
    
    var pattern: RequestPattern {
        RequestPattern(method: .POST, url: url)
    }
    
    var response: ResponseMock {
        ResponseMock(body: try? json("\(url.path)/\(rawValue)"))
    }
    
}

//
//  SendPhoneMock.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Catbird
import Foundation

enum SendPhoneMock: String, RequestBagConvertible {
    
    case phone
    
    var url: URL { URL(string: "/auth/sms/send-code")! }
    
    var pattern: RequestPattern {
        RequestPattern.post(url)
    }
    
    var responseData: ResponseData {
        ResponseData(body: try? json("\(url.path)/\(rawValue)"))
    }
    
}

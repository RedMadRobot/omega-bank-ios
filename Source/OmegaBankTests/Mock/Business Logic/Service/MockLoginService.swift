//
//  MockLoginService.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 3/31/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
@testable import OmegaBank

final class MockLoginService: LoginService {

    private(set) var phone: String?
    private(set) var smsCode: String?
    private(set) var completionHandler: AuthCompletionHandler?
    private(set) var isRestored = false
    let progress = Progress()
    
    // MARK: - LoginService
    
    var isAuthorized: Bool = false
    
    func restore() {
        isRestored = true
    }
    
    func sendPhoneNumber(phone: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        self.phone = phone
        self.completionHandler = completionHandler
        
        return progress
    }
    
    func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        self.smsCode = smsCode
        self.completionHandler = completionHandler
        
        return progress
    }
}

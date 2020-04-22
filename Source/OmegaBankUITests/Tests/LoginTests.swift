//
//  LoginTests.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import XCTest

final class LoginTests: TestBase {
    
    private var auth: LoginScreen!
    private var productListScreen: ProductsScreen!
    
    override func setUp() {

        super.setUp()
        auth = LoginScreen(app: app)
        productListScreen = ProductsScreen(app: app)
        
        launchApp(with: .init(skipAuth: false))
    }
    
    func testSuccesfulLogin() throws {
        addMock(SendPhoneMock.phone)
        addMock(SendSmsCodeMock.smsCode)
        
        XCTAssertFalse(auth.nextButton.isEnabled)
        let validPhone = "\(888_888_88_88)"
        auth.inputPhone(validPhone)
        
        let phone = try XCTUnwrap(auth.phoneField.value as? String)
        
        XCTAssert(auth.nextButton.isEnabled)
        XCTAssertEqual("(888) 888-88-88", phone)
        auth.nextButton.tap()
        XCTAssertFalse(auth.nextButton.isEnabled)
        auth.inputSmsCode()
        XCTAssert(auth.nextButton.isEnabled)
        auth.nextButton.tap()

        XCTAssertTrue(productListScreen.title.waitForExistence(timeout: Timeout.minimum.timeInterval))
    }
    
    func testSmsCodeTextFieldWhenUserGetBackedIsReset() throws {
        addMock(SendPhoneMock.phone)

        XCTAssertFalse(auth.nextButton.isEnabled)
        auth.inputPhone()
        XCTAssert(auth.nextButton.isEnabled)
        auth.nextButton.tap()
        auth.inputSmsCode()
        auth.backButton.tap()
        auth.nextButton.tap()
        
        let smsCode = try XCTUnwrap(auth.smsField.value as? String)
        
        XCTAssertFalse(smsCode.isEmpty)
    }
}

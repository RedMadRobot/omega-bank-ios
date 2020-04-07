//
//  LoginViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 3/31/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import struct OmegaBankAPI.APIError
import struct OmegaBankAPI.AuthData
@testable import OmegaBank
import XCTest

final class LoginViewControllerTests: ViewControllerTestCase {
    
    private var viewController: LoginViewController!
    private var loginService: MockLoginService!
    private var view: UIView { viewController.view }
    private var isAuthorized: Bool = false

    override func setUp() {
        super.setUp()

        isAuthorized = false
        loginService = MockLoginService()
        viewController = LoginViewController(loginService: loginService, stage: .phone)
        viewController.delegate = self
        rootViewController = viewController
    }
    
    func testSuccessLogin() {
        sendPhone(error: nil)
        checkSms(error: nil)
        
        XCTAssertTrue(isAuthorized)
    }
    
    func testSendPhoneWithError() {
        sendPhone(error: URLError(.notConnectedToInternet))
        guard let alert = viewController.presentedViewController as? UIAlertController else {
            return XCTFail("Нет алeрта, \(String(describing: viewController.presentedViewController))")
        }
        
        XCTAssertEqual(alert.preferredStyle, .alert)
        XCTAssertFalse(isAuthorized)
    }
    
    func testSendSmsCodeWithError() {
        sendPhone(error: nil)
        checkSms(error: URLError(.notConnectedToInternet))
        guard let alert = viewController.presentedViewController as? UIAlertController else {
            return XCTFail("Нет алeрта, \(String(describing: viewController.presentedViewController))")
        }
        
        XCTAssertEqual(alert.preferredStyle, .alert)
        XCTAssertFalse(isAuthorized)
    }

    // MARK: - Private
    
    private func sendPhone(
        phone: String = "([999]) [999]-[99]-[99]",
        error: Error?,
        file: StaticString = #file,
        line: UInt = #line) {
        
        guard let nextButton = viewController.assertBarButtonItem(by: "next", file: file, line: line) else { return }
        
        XCTAssertFalse(
            nextButton.isEnabled,
            "Отправка номера телефона доступна при пустом телефонном номере.",
            file: file,
            line: line)

        if let phoneTextField = view.assertSubview(UITextField.self, by: "phone") {
            phoneTextField.userInput(phone)
            // Нам нужно дать InputMask понять что текст изменился и нужно валидировать ввод.
            viewController.textField(phoneTextField, didFillMandatoryCharacters: true, didExtractValue: phone)
        }
        
        XCTAssertTrue(
            nextButton.isEnabled,
            "Отправка номера телефона недоступна при валидном телефонном номере.",
            file: file,
            line: line)
        
        nextButton.userTap()
        
        XCTAssertNotNil(loginService.completionHandler?(error))
        XCTAssertEqual(loginService.phone, phone, "Телефон не отправлен", file: file, line: line)
    }

    private func checkSms(
        with smsCode: String = "9999",
        error: Error?,
        file: StaticString = #file,
        line: UInt = #line) {
        
        guard let nextButton = viewController.assertBarButtonItem(by: "login", file: file, line: line) else { return }
        
        XCTAssertFalse(
            nextButton.isEnabled,
            "Отправка смс кода доступна при пустом текстовом поле.",
            file: file,
            line: line)
        
        view.assertSubview(UITextField.self, by: "code")?.userInput(smsCode)
        
        XCTAssertTrue(
            nextButton.isEnabled,
            "Отправка смс кода недоступна при валидном смс коде.",
            file: file,
            line: line)
        
        nextButton.userTap()
        
        XCTAssertNotNil(loginService.completionHandler?(error))
        XCTAssertEqual(loginService.smsCode, smsCode, "Смс код не отправлен", file: file, line: line)
    }
    
    private func makeApiError(
        _ code: APIError.Code,
        title: String? = nil,
        description: String? = nil,
        retryAfter: TimeInterval? = nil) -> APIError {
        APIError(code: code, title: title, description: description, retryAfter: retryAfter)
    }
}

extension LoginViewControllerTests: LoginViewControllerDelegate {

    func loginViewControllerDidAuth(_ controller: LoginViewController) {
        XCTAssertEqual(viewController, controller)
        isAuthorized = true
    }

}

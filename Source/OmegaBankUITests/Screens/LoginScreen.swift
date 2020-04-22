//
//  LoginScreen.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import XCTest

struct LoginScreen: BaseScreen {
    
    let app: XCUIApplication

    /// Заголовок экрана
    var title: XCUIElement { app.staticTexts[#function] }
    
    /// Текстовое поле для ввода телефона
    var phoneField: XCUIElement { app.textFields["phone"] }
    
    /// Текстовое поле для ввода смс кода
    var smsField: XCUIElement { app.textFields["sms code"] }
    
    /// Navigation Bar
    var navigationBar: XCUIElement { app.navigationBars["Sign In"] }
    
    /// Кнопка "Вперед"
    var nextButton: XCUIElement { navigationBar.buttons["next"] }
    
    /// Кнопка "Назад"
    var backButton: XCUIElement { navigationBar.buttons["back"] }
    
    func inputPhone(_ phone: String = "\(888_888_88_88)") {
        phoneField.tap()
        phoneField.typeText(phone)
    }
    
    func inputSmsCode(_ smsCode: String = "9999") {
        smsField.tap()
        smsField.typeText(smsCode)
    }

}

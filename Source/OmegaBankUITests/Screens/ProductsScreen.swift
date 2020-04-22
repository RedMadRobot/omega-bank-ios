//
//  ProductsScreen.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/17/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import XCTest

struct ProductsScreen: BaseScreen {
    
    let app: XCUIApplication

    /// Заголовок экрана
    var title: XCUIElement { app.staticTexts[#function] }
    
}

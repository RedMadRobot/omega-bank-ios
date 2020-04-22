//
//  TestBase.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Catbird
import XCTest

/// Параметры запуска приложения для UI-тестирования
struct AppLaunchParameters {
    
    /// Приложение запускается в режиме UI-тестирования
    let uiTesting: Bool
    
    /// Экран с авторизацией пропускается
    let skipAuth: Bool
    
    /// Используется локальный мок сервер
    let useLocalMockServer: Bool
    
    /// Адрес локального мок сервера
    var localMockServerURL: String = ""
    
    init(
        uiTesting: Bool = true,
        skipAuth: Bool = true,
        useLocalMockServer: Bool = true) {
        self.uiTesting = uiTesting
        self.skipAuth = skipAuth
        self.useLocalMockServer = useLocalMockServer
    }
    
    var launchArguments: [String] {
        var result = [String]()
        if uiTesting {
            result.append("-ui_testing")
            result.append("1")
        }
        if skipAuth {
            result.append("-skip_auth")
            result.append("1")
        }
        if useLocalMockServer {
            result.append("-API_BASE_URL")
            result.append(localMockServerURL)
        }

        return result
    }
}

class TestBase: XCTestCase {

    // MARK: - Public Properties
    
    static let bundle = Bundle(for: TestBase.self)
    
    let app = XCUIApplication()
    
    // MARK: - Private Properties
    
    private let server = Catbird()
    
    // MARK: - XCTestCase
    
    override func setUp() {
        super.setUp()

        XCTAssertNoThrow(try server.send(.clear))
    }
    
    // MARK: - Public Methods
    
    func addMock(_ mock: RequestBagConvertible, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try server.send(.add(mock)), file: file, line: line)
    }
    
    func removeMock(_ mock: RequestBagConvertible, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try server.send(.remove(mock)), file: file, line: line)
    }
    
    /// Запускает приложение для UI-тестирования с указанными параметрами.
    ///
    /// Параметры запуска по умолчанию:
    /// - Приложение запускается в режиме UI-тестирования
    ///
    /// - Parameter parameters: Параметры запуска приложения.
    func launchApp(with parameters: AppLaunchParameters = AppLaunchParameters()) {
        var params = parameters
        params.localMockServerURL = server.url.absoluteString
        
        app.launchArguments = params.launchArguments
        app.launch()
    }

}

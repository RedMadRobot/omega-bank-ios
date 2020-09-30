//
//  ViewControllerTestCase.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 4/1/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import XCTest

/// Кейс для тестирования вью контроллеров.
///
/// - Note: Не забывайте устанавливать `rootViewController` и вызывать супер у `setUp` и `tearDown`.
class ViewControllerTestCase: XCTestCase {

    /// Окно для показа тестируемых контроллеров.
    ///
    /// - Warning: Переиспользуется во всех тестах контроллеров.
    private static let window = UIWindow(frame: UIScreen.main.bounds)

    /// Окно для показа тестируемых контроллеров.
    var window: UIWindow { ViewControllerTestCase.window }

    /// Слабая ссылка на рутовый контроллер, для поиска утечек памяти.
    private weak var weekViewController: UIViewController?

    /// Рутовый контроллер.
    ///
    /// - Remark: Вызываются все методы жизненного цикла контроллера.
    var rootViewController: UIViewController? {
        get { window.rootViewController }
        set {
            window.rootViewController = newValue
            weekViewController = newValue
        }
    }

    // MARK: - XCTestCase

    override class func setUp() {
        super.setUp()
        // Показать и сделать окно ключевым, если оно ещё не такое.
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Показать и сделать окно ключевым, если оно ещё не такое.
        if !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
    }

    override func tearDown() {
        rootViewController = nil
        XCTAssertNil(weekViewController, "Утечка памяти, контроллер не уничтожился")
        super.tearDown()
    }
    
    // MARK: - Animation

    func waitAnimation(timeout: TimeInterval, animation: () -> Void) {
        let expectaion = expectation(description: "wait animation end")
        CATransaction.begin()
        CATransaction.setCompletionBlock(expectaion.fulfill)
        animation()
        CATransaction.commit()
        waitForExpectations(timeout: timeout, handler: nil)
    }

}

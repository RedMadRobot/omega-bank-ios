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

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        rootViewController = nil
        XCTAssertNil(weekViewController, "Утечка памяти, контроллер не уничтожился")
        super.tearDown()
    }

    // MARK: - Push

    func waitTransition(
        from fromController: UIViewController,
        to toController: UIViewController,
        file: StaticString = #file,
        line: UInt = #line) {

        guard let transition = fromController.transitionCoordinator else {
            XCTFail("No Transition Coordinator for \(fromController)", file: file, line: line); return
        }
        let from = transition.viewController(forKey: .from)
        guard from == fromController else {
            XCTFail("Invalid transition from \(String(describing: from))", file: file, line: line); return
        }
        let to = transition.viewController(forKey: .to)
        guard to == toController else {
            XCTFail("Invalid transition to \(String(describing: to))", file: file, line: line); return
        }
        let expectation = self.expectation(description: "wait presenting")
        transition.animate(alongsideTransition: nil) { _ in expectation.fulfill() }
        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Presentation

    func waitPresenting(_ viewController: UIViewController, file: StaticString = #file, line: UInt = #line) {
        guard let transition = viewController.transitionCoordinator else {
            XCTFail("No Transition Coordinator for \(viewController)", file: file, line: line); return
        }

        let from = transition.viewController(forKey: .from)
        guard from == viewController.presentingViewController else {
            XCTFail("Invalid transition from \(String(describing: from))", file: file, line: line); return
        }

        let to = transition.viewController(forKey: .to)
        guard to == viewController else {
            XCTFail("Invalid transition to \(String(describing: to))", file: file, line: line); return
        }

        let expectation = self.expectation(description: "wait presenting")
        transition.animate(alongsideTransition: nil) { _ in expectation.fulfill() }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func waitDismissing(_ viewController: UIViewController, file: StaticString = #file, line: UInt = #line) {
        guard let transition = viewController.transitionCoordinator else {
            XCTFail("No Transition Coordinator for \(viewController)"); return
        }

        let from = transition.viewController(forKey: .from)
        guard from == viewController else {
            XCTFail("Invalid transition from \(String(describing: from))", file: file, line: line); return
        }

        let to = transition.viewController(forKey: .to)
        guard to == viewController.presentingViewController else {
            XCTFail("Invalid transition to \(String(describing: to))", file: file, line: line); return
        }

        let expectation = self.expectation(description: "wait dismissing")
        transition.animate(alongsideTransition: nil) { _ in expectation.fulfill() }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

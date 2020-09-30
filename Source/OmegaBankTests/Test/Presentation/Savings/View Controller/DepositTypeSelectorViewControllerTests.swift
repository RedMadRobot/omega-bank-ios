//
//  DepositTypeSelectorViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 26.09.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.DepositInfo
import XCTest

final class DepositTypeSelectorViewControllerTests: ViewControllerTestCase, SavingMock {
    
    private var selectorViewController: DepositTypeSelectorViewController!
    
    private var depositTypes: [DepositInfo] {
        [ makeDepositInfo(),
          makeDepositInfo(),
          makeDepositInfo(),
          makeDepositInfo() ]
    }
    
    override func setUp() {
        super.setUp()
        
        selectorViewController = DepositTypeSelectorViewController(depositTypes: depositTypes)
        rootViewController = selectorViewController
    }
    
    func testSuccessLoad() throws {
        let depositViews = try XCTUnwrap(
            selectorViewController?.stackView
                .arrangedSubviews(UIView.self, by: "deposit"))

        XCTAssertEqual(depositViews.count, 4)
        
        let nameLabel = try XCTUnwrap(
            depositViews
                .compactMap { $0.label(by: "title") }
                .first)
        XCTAssertEqual(nameLabel.text, "Deposit")
        
        let aboutTextView = try XCTUnwrap(
            depositViews
                .compactMap { $0.textView(by: "about") }
                .first)
        XCTAssertEqual(aboutTextView.text, "Deposit Description")
    }
    
}

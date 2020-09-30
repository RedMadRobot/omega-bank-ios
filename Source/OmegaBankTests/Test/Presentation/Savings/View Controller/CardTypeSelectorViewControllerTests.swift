//
//  CardTypeSelectorViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 26.09.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.CardInfo
import XCTest

final class CardTypeSelectorViewControllerTests: ViewControllerTestCase, SavingMock {
    
    private var selectorViewController: CardTypeSelectorViewController!
    
    private var cardTypes: [CardInfo] {
        [ makeCardInfo(),
          makeCardInfo(),
          makeCardInfo() ]
    }
    
    override func setUp() {
        super.setUp()
        
        selectorViewController = CardTypeSelectorViewController(cardTypes: cardTypes)
        rootViewController = selectorViewController
    }
    
    func testSuccessLoad() throws {
        let labels = try XCTUnwrap(
            selectorViewController?.stackView
                .arrangedSubviews(UIView.self, by: "card")
                .compactMap { $0.label(by: "name") })
        XCTAssertEqual(labels.count, 3)
        
        let firstCard = try XCTUnwrap(labels.first)
        XCTAssertEqual(firstCard.text, "Card")
    }
    
}

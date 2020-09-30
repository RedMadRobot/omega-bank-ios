//
//  ProductTypeDescriptorViewControllerCardTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 26.09.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.CardInfo
import XCTest

final class ProductTypeDescriptorViewControllerCardTests: ViewControllerTestCase, SavingMock {
    
    private var descriptiorViewController: ProductTypeDescriptorViewController<CardInfo>!
    
    override func setUp() {
        super.setUp()
        
        descriptiorViewController = ProductTypeDescriptorViewController<CardInfo>()
        descriptiorViewController.productInfo = makeCardInfo()
        
        rootViewController = descriptiorViewController
    }
    
    func testSuccessLoad() throws {
        let descriptions = descriptiorViewController.stackView.arrangedSubviews(SubtitleView.self)
        
        XCTAssertEqual(descriptions.count, 3)
        XCTAssertEqual(descriptions[0].label(by: "title")?.text, "Card Caption 1")
        XCTAssertEqual(descriptions[0].label(by: "value")?.text, "Card Value 1")
        XCTAssertEqual(descriptions[1].label(by: "title")?.text, "Card Caption 2")
        XCTAssertEqual(descriptions[1].label(by: "value")?.text, "Card Value 2")
        XCTAssertEqual(descriptions[2].label(by: "title")?.text, "Card Caption 3")
        XCTAssertEqual(descriptions[2].label(by: "value")?.text, "Card Value 3")
    }
    
}

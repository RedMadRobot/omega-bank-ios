//
//  ProductTypeDescriptorViewControllerDepositTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 26.09.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.DepositInfo
import XCTest

final class ProductTypeDescriptorViewControllerDepositTests: ViewControllerTestCase, SavingMock {
    
    private var descriptiorViewController: ProductTypeDescriptorViewController<DepositInfo>!
    
    override func setUp() {
        super.setUp()
        
        descriptiorViewController = ProductTypeDescriptorViewController<DepositInfo>()
        descriptiorViewController.productInfo = makeDepositInfo()
        
        rootViewController = descriptiorViewController
    }
    
    func testSuccessLoad() throws {
        let descriptions = descriptiorViewController.stackView.arrangedSubviews(SubtitleView.self)
        
        XCTAssertEqual(descriptions.count, 3)
        XCTAssertEqual(descriptions[0].label(by: "title")?.text, "Deposit Caption 1")
        XCTAssertEqual(descriptions[0].label(by: "value")?.text, "Deposit Value 1")
        XCTAssertEqual(descriptions[1].label(by: "title")?.text, "Deposit Caption 2")
        XCTAssertEqual(descriptions[1].label(by: "value")?.text, "Deposit Value 2")
        XCTAssertEqual(descriptions[2].label(by: "title")?.text, "Deposit Caption 3")
        XCTAssertEqual(descriptions[2].label(by: "value")?.text, "Deposit Value 3")
    }
    
}

//
//  MainAddDepositViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 8/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.Deposit
import struct OmegaBankAPI.DepositInfo
import XCTest

final class MainAddDepositViewControllerTests: ViewControllerTestCase, SavingMock {
    
    private var depositListService: MockDepositListService!
    private var addDepositViewController: MainAddDepositViewController!
    
    private var didProductTapped = false
    private var didNewProductShown = false

    private var errorViewController: ErrorViewController? {
        addDepositViewController.children.compactMap { $0 as? ErrorViewController }.first
    }
    
    private var applyButton: UIButton? {
        addDepositViewController.view.subview(SubmitButton.self, by: "apply")
    }
    
    private var depositInfo: [DepositInfo] {
        [
            makeDepositInfo(),
            makeDepositInfo(),
            makeDepositInfo(),
            makeDepositInfo()
        ]
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        depositListService = MockDepositListService()
        addDepositViewController = MainAddDepositViewController(listService: depositListService)
        rootViewController = addDepositViewController
    }
    
    override func tearDown() {
        super.tearDown()
        
        addDepositViewController = nil
    }
    
    func testViewDidLoad() throws {
        XCTAssertNil(errorViewController)
        XCTAssertNil(applyButton)
    }
    
    func testSuccessLoadCardInfoList() throws {
        XCTAssertNotNil(depositListService.typesHandler?(.success(depositInfo)))
        XCTAssertNil(errorViewController)
    }
    
    func testLoadCardInfoListWithError() throws {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(depositListService.typesHandler?(.failure(error)))
        XCTAssertNotNil(errorViewController)
    }
    
    func testAddDepositTapped() throws {
        XCTAssertNotNil(depositListService.typesHandler?(.success(depositInfo)))
        
        let button = try XCTUnwrap(applyButton)
        let exp1 = expectation(description: "wait for didProductTapped")
        let exp2 = expectation(description: "wait for didNewProductShown")
        
        let productDelegate = UserProductDelegateMock()
        productDelegate.didProductChanged = {
            button.userTap()
        }
        productDelegate.didProductTapped = {
            exp1.fulfill()
        }
        productDelegate.didNewProductShown = {
            exp2.fulfill()
        }
        addDepositViewController.delegate = productDelegate
        
        wait(for: [exp1, exp2], timeout: 10)
    }
    
}

//
//  MainAddCardViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 8/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.CardInfo
import XCTest

final class MainAddCardViewControllerTests: ViewControllerTestCase, SavingMock {
    
    private var cardListService: MockCardListService!
    private var addCardViewController: MainAddCardViewController!
    
    private var didProductTapped = false
    private var didNewProductShown = false
    
    private var errorViewController: ErrorViewController? {
        addCardViewController.children.compactMap { $0 as? ErrorViewController }.first
    }
    
    private var applyButton: SubmitButton? {
        addCardViewController.view.subview(SubmitButton.self, by: "apply")
    }
    
    private var cardInfo: [CardInfo] {
        [
            makeCardInfo(),
            makeCardInfo(),
            makeCardInfo()
        ]
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        cardListService = MockCardListService()
        addCardViewController = MainAddCardViewController(cardListService: cardListService)
        rootViewController = addCardViewController
    }
    
    override func tearDown() {
        super.tearDown()
        
        addCardViewController = nil
    }
    
    func testViewDidLoad() throws {
        XCTAssertNil(errorViewController)
        XCTAssertNil(applyButton)
    }
    
    func testSuccessLoadCardInfoList() throws {
        XCTAssertNotNil(cardListService.typesHandler?(.success(cardInfo)))
        XCTAssertNil(errorViewController)
    }
    
    func testLoadCardInfoListWithError() throws {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(cardListService.typesHandler?(.failure(error)))
        XCTAssertNotNil(errorViewController)
    }
    
    func testAddCardTapped() throws {
        XCTAssertNotNil(cardListService.typesHandler?(.success(cardInfo)))

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
        addCardViewController.delegate = productDelegate
        
        wait(for: [exp1, exp2], timeout: 10)
    }

}

final class UserProductDelegateMock: UserProductDelegate {

    var didProductChanged: (() -> Void)?
    var didProductTapped: (() -> Void)?
    var didNewProductShown: (() -> Void)?
    
    func didChangeProductType() {
        didProductChanged?()
    }
    
    func didTapNewProduct() {
        didProductTapped?()
    }
    
    func didShowNewProduct(_ product: Product) {
        didNewProductShown?()
    }
    
}

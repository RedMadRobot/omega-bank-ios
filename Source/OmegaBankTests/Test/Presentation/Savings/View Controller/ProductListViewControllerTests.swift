//
//  ProductListViewControllerTests.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 5/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

@testable import OmegaBank
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit
import XCTest

final class MainProductListContainerViewControllerTests: ViewControllerTestCase, SavingMock {
    
    private var containerViewController: MainProductListContainerViewController!
    private var cardListService: MockCardListService!
    private var depositListService: MockDepositListService!
    
    private var cardListViewController: ProductListViewController<Card> {
        containerViewController.cardListViewController
    }
    
    private var depositListViewController: ProductListViewController<Deposit> {
        containerViewController.depositListViewController
    }
    
    private var errorViewController: ErrorViewController? {
        containerViewController.errorViewController
    }
    
    private var cardHeader: ProductHeader? {
        containerViewController.stackView?.arrangedSubview(ProductHeader.self, by: "card header")
    }
    
    private var depositHeader: ProductHeader? {
        containerViewController.stackView?.arrangedSubview(ProductHeader.self, by: "deposit header")
    }
    
    private var addNewCardButton: UIButton? {
        cardHeader?.subview(UIButton.self, by: "add card")
    }
    
    private var addNewDepositButton: UIButton? {
        depositHeader?.subview(UIButton.self, by: "add deposit")
    }
    
    private var cardListCollapsed: Bool {
        cardListViewController.view.frame.height == 0
    }
    
    private var depositListCollapsed: Bool {
        depositListViewController.view.frame.height == 0
    }

    override func setUp() {
        super.setUp()
        
        cardListService = MockCardListService()
        depositListService = MockDepositListService()
        
        containerViewController = MainProductListContainerViewController(
            cardListService: cardListService,
            depositListService: depositListService)

        // Поскольку мы встраиваем контроллер в `UINavigationController`
        // Мы вынуждены ждать анимацию иначе `viewDidLoad` не сработает
        waitAnimation(timeout: 1) {
            rootViewController = UINavigationController(rootViewController: containerViewController)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        containerViewController = nil
    }
    
    private var cards: [Card] {
        [
            makeCard(),
            makeCard(),
            makeCard()
        ]
    }
    
    private var deposits: [Deposit] {
        [
            makeDeposit(),
            makeDeposit(),
            makeDeposit(),
            makeDeposit()
        ]
    }
    
    func testViewDidLoad() throws {
        XCTAssertNotNil(cardHeader)
        XCTAssertNotNil(depositHeader)
        XCTAssertNotNil(addNewCardButton)
        XCTAssertNotNil(addNewDepositButton)
        
        let cards = try XCTUnwrap(cardHeader)
        XCTAssert(!cards.isCollapsed)
        
        let deposits = try XCTUnwrap(cardHeader)
        XCTAssert(!deposits.isCollapsed)
    }
    
    func testSuccessLoadCardList() throws {
        XCTAssertNotNil(cardListService.cardListHandler?(.success(cards)))
        XCTAssertNil(errorViewController)
        try checkCountOfCells(cardListViewController, count: 3)
    }
    
    func testLoadCardListWithError() throws {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(cardListService.cardListHandler?(.failure(error)))
        XCTAssertNotNil(errorViewController)
    }
    
    func testSuccessLoadDepositList() throws {
        XCTAssertNotNil(depositListService.depositListHandler?(.success(deposits)))
        XCTAssertNil(errorViewController)
        try checkCountOfCells(depositListViewController, count: 4)
    }
    
    func testLoadDepositListWithError() throws {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(depositListService.depositListHandler?(.failure(error)))
        XCTAssertNotNil(errorViewController)
    }
    
    func testAddNewCardTappedShowSelector() throws {
        let button = try XCTUnwrap(addNewCardButton)
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        let navigationController = try XCTUnwrap(
            containerViewController.navigationController?.presentedViewController as? NavigationController)
        let titledViewController = try XCTUnwrap(navigationController.topViewController as? TitledPageViewController)
        let child = try XCTUnwrap(titledViewController.children.first)
            
        XCTAssert(child is MainAddCardViewController)
    }
    
    func testAddNewDepositTappedShowSelector() throws {
        let button = try XCTUnwrap(addNewDepositButton)
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        let navigationController = try XCTUnwrap(
            containerViewController.navigationController?.presentedViewController as? NavigationController)
        let titledViewController = try XCTUnwrap(navigationController.topViewController as? TitledPageViewController)
        let child = try XCTUnwrap(titledViewController.children.first)
            
        XCTAssert(child is MainAddDepositViewController)
    }
    
    func testCardListHeaderTappedCollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        
        let button = try XCTUnwrap(cardHeader)
        XCTAssert(!cardListCollapsed)
        
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        
        XCTAssert(cardListCollapsed)
    }
    
    func testDepositListHeaderTappedCollapsed() throws {
        depositListService.depositListHandler?(.success(deposits))
        
        let button = try XCTUnwrap(depositHeader)
        XCTAssert(!depositListCollapsed)
        
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        
        XCTAssert(depositListCollapsed)
    }
    
    func testCardListCardAddedUncollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        depositListService.depositListHandler?(.success(deposits))
        
        containerViewController.didAddProduct(productType: .card)
        
        XCTAssert(!cardListCollapsed)
        XCTAssert(depositListCollapsed)
    }
    
    func testDepositListDepositAddedUncollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        depositListService.depositListHandler?(.success(deposits))
        
        containerViewController.didAddProduct(productType: .deposit)
        
        XCTAssert(cardListCollapsed)
        XCTAssert(!depositListCollapsed)
    }
    
    func testCardCellTappedShowTransactionHistory() throws {
        cardListService.cardListHandler?(.success(cards))
        
        let cardCell = try XCTUnwrap(cardListViewController.stackView.arrangedSubviews(ProductCell.self).first)
        
        waitAnimation(timeout: 2) {
            cardCell.userTap()
        }
        
        let navigationController = try XCTUnwrap(
            containerViewController.navigationController?.presentedViewController as? NavigationController)
        let titledViewController = try XCTUnwrap(navigationController.topViewController as? TitledPageViewController)
        let child = try XCTUnwrap(titledViewController.children.first)
                   
        XCTAssert(child is TransactionHistoryViewController)
    }
    
    func testDepositCellTappedShowTransactionHistory() throws {
        depositListService.depositListHandler?(.success(deposits))
        
        let depositCell = try XCTUnwrap(depositListViewController.stackView.arrangedSubviews(ProductCell.self).first)
        
        waitAnimation(timeout: 2) {
            depositCell.userTap()
        }
        
        let navigationController = try XCTUnwrap(
            containerViewController.navigationController?.presentedViewController as? NavigationController)
        let titledViewController = try XCTUnwrap(navigationController.topViewController as? TitledPageViewController)
        let child = try XCTUnwrap(titledViewController.children.first)
                   
        XCTAssert(child is TransactionHistoryViewController)
    }
    
    // MARK: - Private
    
    private func checkCountOfCells<T>(
        _ viewController: ProductListViewController<T>,
        count: Int,
        file: StaticString = #file,
        line: UInt = #line) throws where T: Product {
        
        XCTAssertEqual(count, viewController.stackView.arrangedSubviews(ProductCell.self).count)
    }
}

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
    
    private var cardListViewController: ProductListViewController<Card>!
    private var depositListViewController: ProductListViewController<Deposit>!
    
    private var errorViewController: ErrorViewController? {
        containerViewController.children.compactMap { $0 as? ErrorViewController }.first
    }
    
    private var cardHeader: ProductHeader? {
        containerViewController.stackView?.arrangedSubview(ProductHeader.self, by: "card header")
    }
    
    private var depositHeader: ProductHeader? {
        containerViewController.stackView?.arrangedSubview(ProductHeader.self, by: "deposit header")
    }
    
    private var addNewCardButton: UIButton? {
        cardHeader?.button(by: "add card")
    }
    
    private var addNewDepositButton: UIButton? {
        depositHeader?.button(by: "add deposit")
    }
    
    private var isCardListCollapsed: Bool {
        cardListViewController.view.frame.height == 0
    }
    
    private var isDepositListCollapsed: Bool {
        depositListViewController.view.frame.height == 0
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
        
        cardListViewController = try XCTUnwrap(
            containerViewController.children
                .compactMap { $0 as? ProductListViewController<Card> }
                .first)
        depositListViewController = try XCTUnwrap(
            containerViewController.children
                .compactMap { $0 as? ProductListViewController<Deposit> }
                .first)
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
        XCTAssertNotNil(cardListViewController)
        XCTAssertNotNil(depositListViewController)
        
        let cards = try XCTUnwrap(cardHeader)
        XCTAssertFalse(cards.isCollapsed)
        
        let deposits = try XCTUnwrap(cardHeader)
        XCTAssertFalse(deposits.isCollapsed)
    }
    
    func testSuccessLoadCardList() throws {
        XCTAssertNotNil(cardListService.cardListHandler?(.success(cards)))
        XCTAssertNil(errorViewController)
        let cells = try XCTUnwrap(cardListViewController.stackView.arrangedSubviews(ProductCell.self))
        XCTAssertEqual(cells.count, 3)
        
        let cell = try XCTUnwrap(cells.first)
        let typeLabel = cell.label(by: "type")
        let valueLabel = cell.label(by: "value")
        let numberLabel = cell.label(by: "number")
        
        XCTAssertEqual(typeLabel?.text, "Visa Classic")
        XCTAssertEqual(valueLabel?.text, "$1111.0")
        XCTAssertEqual(numberLabel?.text, "NNNN RRRR 999 9999 99")
    }
    
    func testLoadCardListWithError() throws {
        let error = URLError(.notConnectedToInternet)
        XCTAssertNotNil(cardListService.cardListHandler?(.failure(error)))
        XCTAssertNotNil(errorViewController)
    }
    
    func testSuccessLoadDepositList() throws {
        XCTAssertNotNil(depositListService.depositListHandler?(.success(deposits)))
        XCTAssertNil(errorViewController)
        let cells = try XCTUnwrap(depositListViewController.stackView.arrangedSubviews(ProductCell.self))
        XCTAssertEqual(cells.count, 4)
        
        let cell = try XCTUnwrap(cells.first)
        let typeLabel = cell.label(by: "type")
        let valueLabel = cell.label(by: "value")
        let numberLabel = cell.label(by: "number")
        
        XCTAssertEqual(typeLabel?.text, "Platinum")
        XCTAssertEqual(valueLabel?.text, "$99999.0")
        XCTAssertEqual(numberLabel?.text, "GGGG MMMM 888 8888 88")
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
            
        XCTAssertTrue(child is MainAddCardViewController)
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
            
        XCTAssertTrue(child is MainAddDepositViewController)
    }
    
    func testCardListHeaderTappedCollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        
        let button = try XCTUnwrap(cardHeader)
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        
        XCTAssertTrue(isCardListCollapsed)
    }
    
    func testDepositListHeaderTappedCollapsed() throws {
        depositListService.depositListHandler?(.success(deposits))
        
        let button = try XCTUnwrap(depositHeader)
        waitAnimation(timeout: 2) {
            button.userTap()
        }
        
        XCTAssertTrue(isDepositListCollapsed)
    }
    
    func testCardListCardAddedUncollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        depositListService.depositListHandler?(.success(deposits))

        waitAnimation(timeout: 2) {
            containerViewController.didAddProduct(productType: .card)
        }
        
        XCTAssertFalse(isCardListCollapsed)
        XCTAssertTrue(isDepositListCollapsed)
    }
    
    func testDepositListDepositAddedUncollapsed() throws {
        cardListService.cardListHandler?(.success(cards))
        depositListService.depositListHandler?(.success(deposits))

        waitAnimation(timeout: 2) {
            containerViewController.didAddProduct(productType: .deposit)
        }
        
        XCTAssertTrue(isCardListCollapsed)
        XCTAssertFalse(isDepositListCollapsed)
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
                   
        XCTAssertTrue(child is TransactionHistoryViewController)
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
                   
        XCTAssertTrue(child is TransactionHistoryViewController)
    }

}

//
//  MainProductListContainerViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 6/6/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.Deposit

protocol ProductTypeDelegate: AnyObject {
    func didAddProduct(productType: ProductType)
}

final class MainProductListContainerViewController: VerticalScrollableViewController {
    
    /// Массив всех продуктовых контроллеров. Используем для переключения  (cхлопывания)
    /// на активную группу при добавлении нового продукта.
    
    private var cardListViewController: ProductListViewController<Card>!
    private var depositListViewController: ProductListViewController<Deposit>!
    
    /// Контроллер для отображения ошибки
    private var errorViewController: ErrorViewController?

    private let cardListService: CardListService
    private let depositListService: DepositListService
    private var progresses: [Progress] = []
    
    private var cardHeader: ProductHeader?
    private var depositHeader: ProductHeader?

    // MARK: - Initialization
    
    init(
        cardListService: CardListService = ServiceLayer.shared.cardListService,
        depositListService: DepositListService = ServiceLayer.shared.depositListService) {

        self.cardListService = cardListService
        self.depositListService = depositListService

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func make(delegate: ProfileViewControllerDelegate?) -> UIViewController {
        let title = "Savings"
        let productList = PageViewController(title: title, tabBarImage: #imageLiteral(resourceName: "signin"))
        productList.delegate = delegate
        
        let vc = MainProductListContainerViewController()
        let titledViewController = TitledPageViewController(
            title: title,
            embeddedViewController: vc
        )
        productList.addChildViewController(titledViewController, to: productList.view)

        let nc = NavigationController(rootViewController: productList)
        return nc
    }
    
    deinit {
        progresses.forEach { $0.cancel() }
    }
    
    // MARK: - MainProductListContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constructScreen()
        
        loadCards()
        loadDeposits()
    }
    
    // MARK: - Public Methods
    
    func toggleProductListViewControllers(with productType: ProductType) {
        if productType == .card {
            cardListViewController.isCollapsed.toggle()
        } else {
            depositListViewController.isCollapsed.toggle()
        }
    }

    private func showError(_ item: ErrorItem) {
        if errorViewController != nil { return }
        
        let vc = ErrorViewController(item) { [weak self] in
            guard let self = self else { return }
            
            self.errorViewController?.removeChildFromParent()
            self.errorViewController = nil
            self.constructScreen()
        }
        
        errorViewController = vc
        clearScreen()
        addArrangedChild(vc)
    }
    
    // MARK: - Private Methods
    
    private func clearScreen() {
        cardListViewController.removeChildFromParent()
        depositListViewController.removeChildFromParent()
        
        stackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
        cardListViewController = nil
        depositListViewController = nil
    }
    
    private func loadCards() {
        let progress = cardListService.load { [weak self] result in
            guard let self = self else { return }
            self.cardHeader?.isAnimated = false
            switch result {
            case .success(let cards):
                let products = cards.map { UserProduct.card($0) }
                self.cardListViewController.products = products
            case .failure(let error):
                self.showError(.error(error))
            }
        }
        
        progresses.append(progress)
    }
    
    private func loadDeposits() {
        let progress = depositListService.load { [weak self] result in
            guard let self = self else { return }
            self.depositHeader?.isAnimated = false
            switch result {
            case .success(let deposits):
                let products = deposits.map { UserProduct.deposit($0) }
                self.depositListViewController.products = products
            case .failure(let error):
                self.showError(.error(error))
            }
        }
        
        progresses.append(progress)
    }
    
    private func constructScreen() {
        addHotActions()
        addSeparator(with: .defaultBackground)
        addSeparator()
        
        addCardList()
        addSeparator()
        addDepositList()
    }

    private func addHotActions() {
        let container = HorizonalScrollableViewController()
        let controller = HotActionListViewController()
        
        addArrangedChild(container)
        container.addArrangedChild(controller)
        
    }
    
    private func addHeader<T>(
        productListViewController: ProductListViewController<T>,
        onPlusTap: @escaping (VoidClosure),
        accessibilityIdentifier: String? = nil,
        addNewAccessibilityIdentifier: String? = nil) -> ProductHeader {
        
        let header = ProductHeader.make(
            title: productListViewController.productType.title,
            onTap: { [unowned self] in
                self.toggleProductListViewControllers(with: productListViewController.productType)
            },
            onPlusTap: {
                onPlusTap()
            },
            accessibilityIdentifier: accessibilityIdentifier,
            addNewProductAccessibilityIdentifier: addNewAccessibilityIdentifier
        )
        
        addArrangedSubview(header)
    
        return header
    }
    
    private func addCardList() {
        cardListViewController = ProductListViewController<Card>(productType: .card, delegate: self)
        
        cardHeader = addHeader(
            productListViewController: cardListViewController,
            onPlusTap: { [unowned self] in
                let vc = MainAddCardViewController.make(delegate: self.cardListViewController)
                self.navigationController?.present(vc, animated: true)
            },
            accessibilityIdentifier: "card header",
            addNewAccessibilityIdentifier: "add card")
        addArrangedChild(cardListViewController)
    }
    
    private func addDepositList() {
        depositListViewController = ProductListViewController<Deposit>(productType: .deposit, delegate: self)
        depositHeader = addHeader(
            productListViewController: depositListViewController,
            onPlusTap: { [unowned self] in
                let vc = MainAddDepositViewController.make(delegate: self.depositListViewController)
                self.navigationController?.present(vc, animated: true)
            },
            accessibilityIdentifier: "deposit header",
            addNewAccessibilityIdentifier: "add deposit")
        addArrangedChild(depositListViewController)
    }

}

extension MainProductListContainerViewController: ProductTypeDelegate {
    
    func didAddProduct(productType: ProductType) {
        cardHeader?.isCollapsed = productType != .card
        cardListViewController.isCollapsed = productType != .card
        depositHeader?.isCollapsed = productType != .deposit
        depositListViewController.isCollapsed = productType != .deposit
    }

}

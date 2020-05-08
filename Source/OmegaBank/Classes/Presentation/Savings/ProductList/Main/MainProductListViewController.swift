//
//  MainProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/9/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol ProductTypeDelegate: AnyObject {
    func didAddProduct(productType: ProductType)
}

extension MainProductListViewController: ProductTypeDelegate {
    
    func didAddProduct(productType: ProductType) {
        
        // текущий контроллер экспандим
        productListViewControllers
            .first(where: { $0.productType == productType })?
            .isCollapsed = false
        
        // остальные коллапсим
        productListViewControllers
            .filter { $0.productType != productType }
            .forEach { $0.isCollapsed = true }
        
    }
}

final class MainProductListViewController: PageViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sectionFooterHeight: CGFloat = 10
    }
    
    // MARK: - Private Properties
    
    private var scrollablePageViewController: ScrollablePageViewController!
    
    private var productListViewControllers: [ProductListViewController] = []
    
    // MARK: - Initialization
    
    static func make(delegate: ProfileViewControllerDelegate?) -> UIViewController {
        let vc = MainProductListViewController()
        vc.delegate = delegate
        return NavigationController(rootViewController: vc)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Savings"
        navigationItem.title = nil
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "signin"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MainProductListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollablePageViewController = ScrollablePageViewController()
        scrollablePageViewController.title = title
        addChildViewController(scrollablePageViewController, to: view)
        
        addHotActions()
        addSeparator(with: .defaultBackground)
        addSeparator()

        let cards: [UserProduct] = [
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 12", value: 30234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 13", value: 12976)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234))
        ]
        
        addProductList(productType: .card, products: cards)
        addSeparator()
        
        let deposits: [UserProduct] = [
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 12", value: 30234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 13", value: 12976)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234))
        ]

        addProductList(productType: .deposit, products: deposits)
    }
    
    // MARK: - Private Methods
    
    private func addHotActions() {
        let controller = HotActionListViewController()
        scrollablePageViewController.addArrangedChild(controller)
    }

    private func addProductList(productType: ProductType, products: [UserProduct]) {
        let controller = ProductListViewController(
            productType: productType,
            products: products,
            delegate: self)
        scrollablePageViewController.addArrangedChild(controller)
        
        productListViewControllers.append(controller)
    }
    
    private func addSeparator(with color: UIColor = .scrollViewBackground) {
        let view = UIView()
        
        view.backgroundColor = color
        scrollablePageViewController.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: Constants.sectionFooterHeight).isActive = true
    }
}

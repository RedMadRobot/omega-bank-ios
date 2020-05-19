//
//  MainProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/9/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import UIKit

protocol ProductTypeDelegate: AnyObject {
    func didAddProduct(productType: ProductType)
}

extension MainProductListViewController: ProductTypeDelegate {
    
    func didAddProduct(productType: ProductType) {
        productListViewControllers.forEach { $0.isCollapsed = $0.productType != productType }
    }

}

final class MainProductListViewController: PageViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sectionFooterHeight: CGFloat = 10
    }
    
    // MARK: - Private Properties
    
    private var scrollablePageViewController: ScrollablePageViewController!
    
    /// Массив всех продуктовых контроллеров. Используем для переключения  (cхлопывания)
    /// на активную группу при добавлении нового продукта.
    private var productListViewControllers: [ProductListPresentable] = []

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
        
        addCardList()
        addSeparator()
        addDepositList()

    }
    
    // MARK: - Private Methods

    private func addHotActions() {
        let controller = HotActionListViewController()
        scrollablePageViewController.addArrangedChild(controller)
    }
    
    private func addCardList() {
        let vc = CardListViewController(delegate: self)
        scrollablePageViewController.addArrangedChild(vc)
        productListViewControllers.append(vc)
    }
    
    private func addDepositList() {
        let vc = DepositListViewController(delegate: self)
        scrollablePageViewController.addArrangedChild(vc)
        productListViewControllers.append(vc)
    }
    
    private func addSeparator(with color: UIColor = .scrollViewBackground) {
        let view = UIView()
        
        view.backgroundColor = color
        scrollablePageViewController.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: Constants.sectionFooterHeight).isActive = true
    }
}

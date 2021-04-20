//
//  ProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import OmegaBankAPI
import UIKit

final class ProductListViewController<T>: StackedViewController where T: Product {

    // MARK: - Public Properties
    
    var products: [UserProduct] = [] {
        didSet {
            addCells()
        }
    }
    
    let productType: ProductType
    
    // MARK: - Private Properties

    private weak var delegate: ProductTypeDelegate?

    // MARK: - Initializaiton
    
    init(
        productType: ProductType,
        delegate: ProductTypeDelegate?) {
        
        self.productType = productType
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods

    private func addCells() {
        for i in 0..<products.count {
            addCell(products[i])
            
            // После последней ячейки сепаратор не ставим.
            let isLast = i == products.count - 1
            if !isLast {
                addSeparator()
            }
        }
    }
    
    private func makeCell(_ product: Product) -> ProductCell {
        ProductCell.make(
            viewModel: ProductViewModel.make(product),
            onTap: { [unowned self] in
                self.didProductTapped(product)
            },
            image: #imageLiteral(resourceName: "credit_card")
        )
    }
    
    private func addCell(_ product: Product) {
        let cell = makeCell(product)

        stackView.addArrangedSubview(cell)
    }
    
    func addNewCell(_ product: Product) {
        let separator = SeparatorView.loadFromNib()
        let cell = makeCell(product)
        
        insertArrangedSubview(separator, at: 0)
        insertArrangedSubview(cell, at: 0)
    }

    private func didProductTapped(_ product: Product) {
        let vc = TransactionHistoryViewController()
        let titledViewController = TitledPageViewController(
            title: "Transaction History",
            embeddedViewController: vc,
            hasDismissedButton: true)
        
        let nc = NavigationController(rootViewController: titledViewController)
        
        present(nc, animated: true)
    }
}

extension ProductListViewController: UserProductDelegate {
    
    func didShowNewProduct(_ product: Product) {
        addNewCell(product)
    }

    func didTapNewProduct() {
        delegate?.didAddProduct(productType: productType)
    }

}

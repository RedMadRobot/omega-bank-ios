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
    
    var addProductTapped: (() -> Void)?

    // MARK: - Private Properties
    
    private var header: ProductHeader!
    private var products: [UserProduct] = []
    private weak var delegate: ProductTypeDelegate?
    private let productType: ProductType

    // MARK: - Initializaiton
    
    init(
        productType: ProductType,
        products: [UserProduct],
        delegate: ProductTypeDelegate?) {
        
        self.productType = productType
        self.products = products
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ProductListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeader()
        addCells()
    }

    // MARK: - StackedViewController
    
    override func didToggle() {
        header.isCollapsed.toggle()
    }
    
    // MARK: - Private Methods

    private func addHeader() {
        header = ProductHeader.make(
            title: productType.title,
            onTap: { [unowned self] in
                self.isCollapsed.toggle()
            },
            onPlusTap: { [unowned self] in
                self.addProductTapped?()
            }
        )
        
        addArrangedSubview(header)
    }
    
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
        
        addArrangedSubview(cell)
    }
    
    func addNewCell(_ product: Product) {
        let separator = SeparatorView.loadFromNib()
        let cell = makeCell(product)
        
        insertArrangedSubview(separator, at: 1) // т.к. по 0 индексу - хедер
        insertArrangedSubview(cell, at: 1) // т.к. по 0 индексу - хедер

        toggleAnimator?.animate(cell: cell)
        toggleAnimator?.animate(cell: separator, index: 1)
    }

    private func didProductTapped(_ product: Product) {
        let vc = MainTransactionHistoryViewController.make()
        present(vc, animated: true)
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

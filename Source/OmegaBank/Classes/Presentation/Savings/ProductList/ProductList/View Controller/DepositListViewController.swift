//
//  DepositListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Deposit

final class DepositListViewController: UIViewController, ProductListPresentable, ErrorHandler {
    
    // MARK: - ProductBehaviour
    
    var isCollapsed: Bool = false {
        willSet {
            productListViewController?.isCollapsed = newValue
        }
    }
    
    var productListViewController: StackedViewController?
    var productType: ProductType { .deposit }
    
    // MARK: - Private Properties
    
    private let depositListService: DepositListService
    private var progress: Progress?
    private weak var delegate: ProductTypeDelegate?

    // MARK: - Initializaiton

    init(
        depositListService: DepositListService = ServiceLayer.shared.depositListService,
        delegate: ProductTypeDelegate?) {
        self.depositListService = depositListService
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        progress?.cancel()
    }
    
    // MARK: - CardListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
    }

    // MARK: - Private Methods
    
    private func loadProducts() {
        progress = depositListService.load { [weak self] result in
            self?.loadDidFinish(result)
        }
    }

    private func loadDidFinish(_ result: Result<[Deposit]>) {
        switch result {
        case .success(let cards):
            showProducts(cards)
        case .failure(let error):
            showError(.error(error, onAction: { [weak self] in
                self?.loadProducts()
            }))
        }
    }
    
    private func showProducts(_ products: [Deposit]) {
        let userProducts = products.map { UserProduct.deposit($0) }
        let vc = ProductListViewController<Deposit>(
            productType: .deposit,
            products: userProducts,
            delegate: delegate)
        
        vc.addProductTapped = { [unowned self] in
            let vc = MainAddDepositViewController.make(delegate: vc)
            self.present(vc, animated: true)
        }
        
        addChildViewController(vc, to: view)
        productListViewController = vc
    }
    
}

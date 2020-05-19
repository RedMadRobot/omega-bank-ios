//
//  CardListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Card

protocol ProductListPresentable: AnyObject {
    var productType: ProductType { get }
    var isCollapsed: Bool { get set }
}

final class CardListViewController: UIViewController, ProductListPresentable {

    // MARK: - ProductBehaviour
    
    var isCollapsed: Bool = false {
        willSet {
            productListViewController?.isCollapsed = newValue
        }
    }
    
    var productListViewController: StackedViewController?
    var productType: ProductType { .card }
    
    // MARK: - Private Properties
    
    private let cardListService: CardListService
    private var progress: Progress?
    private weak var delegate: ProductTypeDelegate?
    
    // MARK: - Initializaiton

    init(
        cardListService: CardListService = ServiceLayer.shared.cardListService,
        delegate: ProductTypeDelegate?) {
        self.cardListService = cardListService
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
        progress = cardListService.load(completion: { [weak self] result in
            self?.loadDidFinish(result)
        })
    }

    private func loadDidFinish(_ result: Result<[Card]>) {
        switch result {
        case .success(let cards):
            showProducts(cards)
        case .failure(let error):
            showError(.error(error))
        }
    }
    
    private func showProducts(_ products: [Card]) {
        let userProducts = products.map { UserProduct.card($0) }
        let vc = ProductListViewController<Card>(
            productType: .card,
            products: userProducts,
            delegate: delegate)
        
        vc.addProductTapped = { [unowned self] in
            let vc = MainAddCardViewController.make(delegate: vc)
            self.present(vc, animated: true)
        }
        
        addChildViewController(vc, to: view)
        productListViewController = vc
    }
    
    private func showError(_ item: ErrorItem) {
        var message = "Что-то пошло не так"
        
        switch item {
        case .error(let error):
            message = error.localizedDescription
        case .empty:
            message = "В данный момент нет доступных банковских продуктов"
        }

        let alert = UIAlertController(
            title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

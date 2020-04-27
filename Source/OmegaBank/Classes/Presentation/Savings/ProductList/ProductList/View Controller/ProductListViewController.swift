//
//  ProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ProductListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sectionFooterHeight: CGFloat = 10
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableStackView: UIStackView!
    
    // MARK: - Private Properties
    
    private var productTypes: [String] = ["Deposit cards", "Bank Accouts"]
    private var animator: AppearingViewAnimator!
    
    // TODO: Есть вероятность что это можно сделать лучше.
    var wasPresenter = false
    
    private var products: [String: [UserProduct]] = [
        "Deposit cards": [
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 12", value: 30234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 13", value: 12976)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234)),
            .card(Card(name: "Deposit card", number: "NDSL RA01 203 4455 14", value: 51234))
        ],
        
        "Bank Accouts": [
            .deposit(Deposit(name: "Bank accout", number: "NDSL RA01 203 4455 01", value: 1233)),
            .deposit(Deposit(name: "Bank accout", number: "NDSL RA01 203 4455 02", value: 5234)),
            .deposit(Deposit(name: "Bank accout", number: "NDSL RA01 203 4455 03", value: 6225)),
            .deposit(Deposit(name: "Bank accout", number: "NDSL RA01 203 4455 03", value: 6225))
        ]
    ]
    
    // MARK: - ProductListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSections()
        addAppearingAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !wasPresenter {
            animateAppearing()
            
            wasPresenter = true
        }
    }
    
    // MARK: - Private Methods
    
    private func addSections() {
        for i in 0..<productTypes.count {
            let isLast = i == productTypes.count - 1
            addSection(productTypes[i], isLast: isLast)
        }
    }
    
    private func addSection(_ productType: String, isLast: Bool) {
        addHeader(productType)
        addCells(productType)
        
        if !isLast {
            // Т.к. футер используется как разделитель, то в последней секции мы его не ставим.
            addFooter()
        }
    }
    
    private func addHeader(_ productType: String) {
        let header = ProductHeader.make(title: productType)
        tableStackView.addArrangedSubview(header)
    }
    
    private func addCells(_ productType: String) {
        guard let products = products[productType] else { return }
        for i in 0..<products.count {
            addCell(products[i])
            
            // После последней ячейки сепаратор не ставим.
            let isLast = i == products.count - 1
            if !isLast {
                addSeparator()
            }
        }
    }
    
    private func addCell(_ product: UserProduct) {
        let cell = ProductCell.make(
            viewModel: ProductViewModel.make(product),
            onTap: { [unowned self] in
                self.didProductTapped(product)
            },
            image: #imageLiteral(resourceName: "credit_card")
        )
        
        tableStackView.addArrangedSubview(cell)
    }
    
    private func addSeparator() {
        let separator = SeparatorView.loadFromNib()
        tableStackView.addArrangedSubview(separator)
    }
    
    private func addFooter() {
        let view = UIView()
        view.backgroundColor = .scrollViewBackground
        tableStackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: Constants.sectionFooterHeight).isActive = true
    }
    
    private func addAppearingAnimation() {
        let fullDuration = MainProductListConstants.fullAppearingDuration
        let oneItemDuration = MainProductListConstants.oneItemAppearingDuration
        
        let delay = (fullDuration - oneItemDuration) / Double(tableStackView.arrangedSubviews.count) 
        let animation = AppearingViewAnimator.makeMove(
            startOrigin: CGPoint(x: 0, y: tableStackView.frame.height),
            duration: oneItemDuration,
            delay: delay)
        animator = AppearingViewAnimator(animation: animation)
    }
    
    private func animateAppearing() {
        for (i, view) in tableStackView.arrangedSubviews.enumerated() {
            animator.animate(cell: view, index: i)
        }
    }
    
    private func didProductTapped(_ product: UserProduct) {
        let vc = MainTransactionHistoryViewController.make()
        present(vc, animated: true)
    }
    
}

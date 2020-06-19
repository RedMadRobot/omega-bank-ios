//
//  TransactionHistoryViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class TransactionHistoryViewController: VerticalScrollableViewController {

    // MARK: - Private Properties
    
    private var transactions = [
        Transaction(name: "Lunch time", value: -20, date: Date()),
        Transaction(name: "Freelance work", value: 500, date: Date()),
        Transaction(name: "New Jean", value: -23, date: Date()),
        Transaction(name: "Lunch time", value: -20, date: Date()),
        Transaction(name: "Freelance work", value: 500, date: Date()),
        Transaction(name: "New Jean", value: -23, date: Date()),
        Transaction(name: "Lunch time", value: -20, date: Date()),
        Transaction(name: "Freelance work", value: 500, date: Date()),
        Transaction(name: "New Jean", value: -23, date: Date()),
        Transaction(name: "Lunch time", value: -20, date: Date()),
        Transaction(name: "Freelance work", value: 500, date: Date()),
        Transaction(name: "New Jean", value: -23, date: Date())
    ]
    
    // MARK: - TransactionHistoryViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCells()
    }
    
    // MARK: - Private Methods
    
    private func addCells() {
        for i in 0..<transactions.count {
            addCell(transaction: transactions[i])
            
            // После последней ячейки сепаратор не ставим.
            let isLast = i == transactions.count - 1
            if !isLast {
                addSeparator()
            }
        }
    }

    private func addCell(transaction: Transaction) {
        let productCell = ProductCell.make(
            viewModel: ProductViewModel.make(transaction),
            image: #imageLiteral(resourceName: "credit_card"))
        
        addArrangedSubview(productCell)
    }
    
    private func addSeparator() {
        let separator = SeparatorView.loadFromNib()
        addArrangedSubview(separator)
    }

}

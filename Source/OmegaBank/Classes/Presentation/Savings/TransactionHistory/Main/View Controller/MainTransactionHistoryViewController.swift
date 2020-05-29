//
//  MainTransactionHistoryViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class MainTransactionHistoryViewController: ViewController {
    
    // MARK: - Nested Properties
    
    override var hasDismissedButton: Bool { true }
    
    // MARK: - Initialization
    
    static func make() -> UIViewController {
        let vc = MainTransactionHistoryViewController()
        return NavigationController(rootViewController: vc)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Transaction History"
        navigationItem.title = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MainTransactionHistoryViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerViewController = ScrollablePageViewController()
        containerViewController.title = title
        addChildViewController(containerViewController, to: view)
        
        let transactionHistoryViewController = TransactionHistoryViewController()
        containerViewController.addArrangedChild(transactionHistoryViewController)
    }
}

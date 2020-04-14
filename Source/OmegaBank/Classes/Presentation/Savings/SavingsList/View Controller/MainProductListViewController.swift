//
//  MainProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/9/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class MainProductListViewController: PageViewController {
    
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
        
        let scrollablePageViewController = ScrollablePageViewController()
        scrollablePageViewController.title = title
        addChildViewController(scrollablePageViewController, to: view)
        
        let controller = ProductListViewController()
        scrollablePageViewController.addArrangedChild(controller)
    }

}

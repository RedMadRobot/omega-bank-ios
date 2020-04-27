//
//  MainProductListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/9/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

enum MainProductListConstants {

    // Animation
    /// Длительность полной анимации появления экрана.
    static let fullAppearingDuration = 1.0
    /// Длительность полной анимации одного элемента. Должно быть меньше, чем fullAppearingDuration
    static let oneItemAppearingDuration = 0.5
}

final class MainProductListViewController: PageViewController {
    
    // MARK: - Private Properties
    
    var scrollablePageViewController: ScrollablePageViewController!
    
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
        addProductList()
    }
    
    // MARK: - Private Methods
    
    private func addHotActions() {
        let controller = HotActionListViewController()
        scrollablePageViewController.addArrangedChild(controller)
    }

    private func addProductList() {
        let controller = ProductListViewController()
        scrollablePageViewController.addArrangedChild(controller)
    }
}

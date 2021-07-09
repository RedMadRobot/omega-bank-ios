//
//  PageViewControllerFactory.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

/// Фабрика создания стартовых VC для таббара
protocol PageViewControllerFactory: AnyObject {
    
    func makeMainProductListContainerViewController(delegate: ProfileViewControllerDelegate) -> UIViewController
    
    func makePartnerListContainerViewController(delegate: ProfileViewControllerDelegate) -> UIViewController
    
    func makeMapViewController(delegate: ProfileViewControllerDelegate) -> UIViewController
    
}

public class TabBarScreenFactory: PageViewControllerFactory {
    
    func makeMainProductListContainerViewController(delegate: ProfileViewControllerDelegate) -> UIViewController {
        let title = "Savings"
        let productList = PageViewController(title: title, tabBarImage: #imageLiteral(resourceName: "signin"))
        productList.delegate = delegate
        
        let vc = MainProductListContainerViewController()
        let titledViewController = TitledPageViewController(
            title: title,
            embeddedViewController: vc
        )
        productList.addChildViewController(titledViewController, to: productList.view)

        let nc = NavigationController(rootViewController: productList)
        return nc
    }
    
    func makePartnerListContainerViewController(delegate: ProfileViewControllerDelegate) -> UIViewController {
        let vc = PartnerListContainerViewController()
        vc.delegate = delegate
        return NavigationController(rootViewController: vc)
    }
    
    func makeMapViewController(delegate: ProfileViewControllerDelegate) -> UIViewController {
        let vc = MapViewController()
        vc.delegate = delegate
        return NavigationController(rootViewController: vc)
    }
    
}

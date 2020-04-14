//
//  PageViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 10.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {

    /// Обработка логаута из главного экрана
    func mainViewControllerDidLogout()
}

class PageViewController: UIViewController {

    // MARK: - Public properties

    weak var delegate: ProfileViewControllerDelegate?

    // MARK: - ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "logout"),
            style: .plain,
            target: self,
            action: #selector(logout))
    }

    @objc private func logout() {
        delegate?.mainViewControllerDidLogout()
    }
}

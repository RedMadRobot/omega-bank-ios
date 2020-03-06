//
//  MainViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 03.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Private properties
    
    private let loginService: LoginService
    private var isAuthorized: Bool { loginService.isAuthorized }

    // MARK: - Init
    
    init(loginService: LoginService = ServiceLayer.shared.loginService) {
        self.loginService = loginService
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIUiewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isAuthorized {
            showLogin()
        }
    }
    
    // MARK: - Private
    
    private func showLogin() {
        let loginViewController = LoginViewController(loginService: loginService)
        let navigationController = NavigationController(rootViewController: loginViewController)
        
        present(navigationController, animated: false, completion: nil)
    }

}

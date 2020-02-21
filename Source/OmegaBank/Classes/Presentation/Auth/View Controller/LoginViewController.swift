//
//  LoginViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 18.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var smsCodeTextField: UITextField!
    
    private var progress: Progress?
    
    private let loginService: LoginService
    private var isValid: Bool {
        smsCodeTextField.hasText
    }

    // MARK: - Init

    init(
        loginService: LoginService = ServiceLayer.shared.loginService) {
        self.loginService = loginService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progress?.cancel()
    }
    
    // MARK: - Actions
    
    @IBAction func sendSMSCode(_ sender: Any) {
        progress = loginService.sendPhoneNumber(
            phone: smsCodeTextField.text ?? "") { [weak self] error in
                guard
                    let self = self,
                    error == nil
                    else { return
                }
                self.handlePhoneRegistration()
        }
    }
    
    // MARK: - Private
    
    private func handlePhoneRegistration() {
        progress = loginService.checkSmsCode(smsCode: "123") { error in
            guard error != nil else {
                return
            }
        }
    }
}

//
//  PinCodeCreateViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol PinCodeCreateViewControllerDelegate: AnyObject {
    func pinCodeCreateViewControllerDidMake(_ controller: PinCodeCreateViewController)
}

final class PinCodeCreateViewController: PinCodeBaseViewController, AlertPresentable {
    
    // MARK: - Private Types
    
    private enum Constants {
        static let titleVC = "Sign Up"
        
        static let titleCreate = "Create PIN"
        static let titleRepeat = "Repeat PIN"
        
        static let titleErrorPin = "PIN incorrect"
        static let titleErrorSave = "Error"
        
        static let titleAlertAuth = "Do you want to allow the App to use biometric credential?"
        static let textAlertAuth = "This will help you log in faster"
        static let titleOkButton = "Allow"
        static let titleCancelButton = "Don't allow"
        
        static let biometricReason = "Please authenticate yourself"
    }
    
    private enum State: Equatable {
        case create
        case confirm(String)
    }
    
    // MARK: - Public Properties
    
    weak var delegate: PinCodeCreateViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var state = State.create
    
    private var loginService: LoginService
    
    // MARK: - Init
    
    init(loginService: LoginService) {
        self.loginService = loginService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.titleVC
        
        titleText = Constants.titleCreate
        isHiddenAvatarImage = true
    }
    
    // MARK: - Private Methods
    
    private func updateState(with newPinCode: String) {
        switch state {
        case .create:
            state = .confirm(newPinCode)
            titleText = Constants.titleRepeat
            clearInput(with: .push)
        case .confirm(let pinCode) where newPinCode == pinCode:
            isKeyboardEnabled = true
            updateRightButton()
            save()
        case .confirm:
            state = .create
            titleText = Constants.titleCreate
            showError(message: Constants.titleErrorPin)
            clearInput(with: .shakeAndPop)
        }
    }
    
    /// Сброс состояния создания пин-кода
    private func resetState() {
        titleText = Constants.titleCreate
        showError(message: Constants.titleErrorSave)
        state = .create
    }
    
    /// Сохранение токена по пин-коду
    private func save() {
        do {
            try saveToken(by: pinCode)
        } catch {
            resetState()
        }
    }
    
    /// Сохранение пин-кода с предложением использовать биометрию
    private func saveToken(by pinCode: String) throws {
        switch loginService.hasBiometricPermission {
        case false:
            try? saveTokenWithBiometry(by: pinCode)
        case true:
            showAlert(
                title: Constants.titleAlertAuth,
                text: Constants.textAlertAuth,
                okTitleAction: Constants.titleOkButton,
                cancelTitleAction: Constants.titleCancelButton) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case true:
                    try? self.saveTokenWithBiometry(by: pinCode)
                case false:
                    try? self.loginService.setToken(by: pinCode)
                    self.delegate?.pinCodeCreateViewControllerDidMake(self)
                }
            }
        }
    }
    
    /// Сохранение пин-кода через биометрию
    private func saveTokenWithBiometry(by pinCode: String) throws {
        loginService.evaluateBiometry(reason: Constants.biometricReason) { [weak self] result in
            guard let self = self else { return }
            
            try? self.loginService.set(biometricSystemPermission: true)
            
            switch result {
            case .success:
                try? self.loginService.setTokenWithBiometry(by: pinCode)
            case .failure:
                try? self.loginService.setToken(by: pinCode)
            }
            self.delegate?.pinCodeCreateViewControllerDidMake(self)
        }
    }
    
    // MARK: - PinCodeCreateViewControllerDelegate
    
    @objc override func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect digit: String) {
        super.pinCodeKeyboardView(keyboard, didSelect: digit)
        
        verifyPinCode { [weak self] in
            guard let self = self else { return }
            self.updateState(with: self.pinCode)
        }
    }
    
}

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

final class PinCodeCreateViewController: PinCodeBaseViewController {
    
    // MARK: - Types
    
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
    
    // MARK: - VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign Up"
        
        titleText = "Придумайте пин-код для быстрого входа"
        isHiddenAvatarImage = true
    }
    
    // MARK: - Private Methods
    
    private func updateState(with newPinCode: String) {
        switch state {
        case .create:
            state = .confirm(newPinCode)
            titleText = "Повторите \nваш пин-код"
            clearInput(with: .push)
        case .confirm(let pinCode) where newPinCode == pinCode:
            isKeyboardEnabled = true
            updateRightButton()
            save()
        case .confirm:
            state = .create
            titleText = "Придумайте пин-код для быстрого входа"
            showError(message: "Пин-коды не совпадают")
            clearInput(with: .shakeAndPop)
        }
    }
    
    /// Сброс состояния создания пин-кода
    private func resetState() {
        titleText = "Придумайте пин-код для быстрого входа"
        showError(message: "Произошла ошибка")
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
            showAuthenticationAlert { [weak self] result in
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
        loginService.evaluateBiometry(reason: "Предоставить доступ к биометрии?") { [weak self] result in
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
    
    @objc override func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect digit: String) {
        super.pinCodeKeyboardView(keyboard, didSelect: digit)
        
        verifyPinCode { [weak self] in
            guard let self = self else { return }
            self.updateState(with: self.pinCode)
        }
    }

}

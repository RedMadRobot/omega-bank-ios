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
    
    // MARK: - Init
    
    // MARK: - VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        
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
            savePinCode()
        case .confirm:
            state = .create
            titleText = "Придумайте пин-код для быстрого входа"
            showError(message: "Пин-коды не совпадают")
            clearInput(with: .shakeAndPop)
        }
    }
    
    // Сброс состояния создания пин-кода
    private func resetState() {
        titleText = "Придумайте пин-код для быстрого входа"
        showError(message: "Произошла ошибка")
        state = .create
    }
    
    private func savePinCode() {
        delegate?.pinCodeCreateViewControllerDidMake(self)
    }
    
    // Метод сохранения пин-кода
    private func save() {
        
    }
    
    // Метод сохранения биометрии
    private func saveWithBiometry() {
        
    }
    
    @objc override func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect digit: String) {
        super.pinCodeKeyboardView(keyboard, didSelect: digit)
        
        verifyPinCode { [weak self] in
            guard let self = self else { return }
            self.updateState(with: self.pinCode)
        }
    }

}

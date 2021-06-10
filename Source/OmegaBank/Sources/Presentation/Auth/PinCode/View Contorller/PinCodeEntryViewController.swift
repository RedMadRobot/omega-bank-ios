//
//  PinCodeEntryViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 10.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

final class PinCodeEntryViewController: PinCodeController {
    
    // MARK: - Public properties
    
    // Кол-бэк на вход
    var onEntry: (() -> Void)?
    
    // Кол-бэк на выход
    var onExitButtonPressed: (() -> Void)?
    
    // MARK: - Private properties
    
    private var wrongInputAttempts = 3
    
    // MARK: - VC
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHiddenAvatarImage = false
    }
    
    // MARK: - Private methods
    
    private func showError(with wrongInputAttempts: Int) {
        showError(message: "Не правильный пинкод \n Кол-во оставшихся попыток — \(wrongInputAttempts)")
    }
    
    // Вход по пин-коду
    private func authoriseByPinCode() {

    }
    
    // Вход по биометрии
    private func entryBiometry() {

    }
    
    // Установка правой кнопки клавиатуры в зависимости от типа биометрии
    private func setRightButtonBiometricType() {

    }
    
    // Ввод пин-кода
    override func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect number: String) {
        super.pinCodeKeyboardView(keyboard, didSelect: number)
        
        verifyPinCode { [weak self] in
            self?.authoriseByPinCode()
        }
    }
    
    // Сброс пароля
    override func pinCodeKeyboardViewDidSelectLeftButton(_ keyboard: PinCodeKeyboardView) {
        super.pinCodeKeyboardViewDidSelectLeftButton(keyboard)
        onExitButtonPressed?()
    }
    
    // Вход по биометрии
    override func pinCodeKeyboardViewDidSelectRightButton(_ keyboard: PinCodeKeyboardView) {
        super.pinCodeKeyboardViewDidSelectRightButton(keyboard)
        
        if !pinCode.isEmpty {
            removeLastNumber()
            updateRightButton()
        } else {
            entryBiometry()
        }
    }
}

//
//  PinCodeEntryViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 10.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

protocol PinCodeEntryViewControllerDelegate: AnyObject {
    
    func pinCodeEntryViewControllerEntered(_ controller: PinCodeEntryViewController)
    
    func pinCodeEntryViewControllerDidLogout(_ controller: PinCodeEntryViewController)
    
}

final class PinCodeEntryViewController: PinCodeBaseViewController {
    
    // MARK: - Private Types
    
    enum TextConstants {
        static let titleVC = "Sign In"
        static let errorPin = "Incorrect PIN \n Remaining attempts — "
        static let errorBio = "Incorrect bio"
    }
    
    // MARK: - Public properties
    
    weak var delegate: PinCodeEntryViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var loginService: LoginService
    
    private var maxInputAttempts = 3
    
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
        
        title = TextConstants.titleVC
        isHiddenAvatarImage = false
        isExitButtonHidden = false
        setRightButtonBiometricType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authoriseBiometry()
    }
    
    // MARK: - Private methods
    
    private func showPinError(with wrongInputAttempts: Int) {
        showError(message: TextConstants.errorPin + String(wrongInputAttempts))
    }
    
    private func showBioError() {
        showError(message: TextConstants.errorBio)
    }
    
    // Вход по пин-коду
    private func authorise(by pinCode: String) {
        do {
            try loginService.authorise(by: pinCode)
            delegate?.pinCodeEntryViewControllerEntered(self)
        } catch {
            if maxInputAttempts == 1 {
                delegate?.pinCodeEntryViewControllerDidLogout(self)
                return
            }
            maxInputAttempts -= 1
            showPinError(with: maxInputAttempts)
        }
    }
    
    // Вход по биометрии
    private func authoriseBiometry() {
        guard loginService.hasBiometricEntry else { return }
        loginService.authoriseWithBiometry { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.pinCodeEntryViewControllerEntered(self)
            case .failure:
                self.showBioError()
            }
        }
    }
    
    // Установка правой кнопки клавиатуры в зависимости от типа биометрии
    private func setRightButtonBiometricType() {
        guard loginService.hasBiometricEntry else {
            rightButtonItem = .nothing
            updateRightButton()
            return
        }
        
        switch loginService.biometricType {
        case .faceID:
            rightButtonItem = .faceID
        case .touchID:
            rightButtonItem = .touchID
        default:
            rightButtonItem = .nothing
        }
        updateRightButton()
    }
    
    // Ввод пин-кода
    override func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect digit: String) {
        super.pinCodeKeyboardView(keyboard, didSelect: digit)
        
        verifyPinCode { [weak self] in
            guard let self = self else { return }
            self.authorise(by: self.pinCode)
        }
    }
    
    // Сброс пароля
    override func pinCodeKeyboardViewDidSelectLeftButton(_ keyboard: PinCodeKeyboardView) {
        super.pinCodeKeyboardViewDidSelectLeftButton(keyboard)
        delegate?.pinCodeEntryViewControllerDidLogout(self)
    }
    
    // Вход по биометрии
    override func pinCodeKeyboardViewDidSelectRightButton(_ keyboard: PinCodeKeyboardView) {
        if !pinCode.isEmpty {
            removeLastDigit()
            updateRightButton()
        } else {
            authoriseBiometry()
        }
    }
}

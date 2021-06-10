//
//  PinCodeViewController.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

class PinCodeController: UIViewController {
    
    // MARK: - Public Properties
    
    var pinCode = ""
    
    var rightButtonItem: RightButtonItem = .nothing
    
    var titleText: String? {
        didSet {
            pinView.titleText = titleText
        }
    }
    
    var isHiddenExitButton: Bool = false {
        didSet {
            pinView.isHiddenExitButton = isHiddenExitButton
        }
    }
    
    var isHiddenAvatarImage: Bool = false {
        didSet {
            pinView.isHiddenAvatarImage = isHiddenAvatarImage
        }
    }
    
    var isPinCodeCompleted: Bool {
        pinCode.count == 4
    }
    
    var isEnabledKeyboard: Bool = true {
        didSet {
            pinView.isEnableKeyboard = isEnabledKeyboard
        }
    }
    
    // MARK: - Private Properties
    
    private let pinView = PinCodeView()
    
    override func loadView() {
        view = pinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pinView.delegate = self
    }
    
    // MARK: - Public methods
    // Отображение ошибки ввода пин-кода
    func showError(message: String) {
        pinView.showError(errorMessage: message)
        clearInput(with: .shakeAndPop)
    }
    
    // Сброс ввода пин-кода
    func clearInput(with animation: ClearAnimation) {
        pinCode = ""
        pinView.clearInput(animation: animation) { [weak self] in
            self?.pinView.isEnableKeyboard = true
            self?.updateRightButton()
        }
    }
    
    // Обновление правой нижней кнопки в клавиатуре ввода пин-кода
    func updateRightButton() {
        if pinCode.isEmpty {
            switch rightButtonItem {
            case .nothing:
                pinView.setRightButton(rightButtonItem: .nothing)
            case .touchID:
                pinView.setRightButton(rightButtonItem: .touchID)
            case .faceID:
                pinView.setRightButton(rightButtonItem: .faceID)
            default:
                break
            }
        } else {
            pinView.setRightButton(rightButtonItem: .delete)
        }
    }
    
    func verifyPinCode(completion: @escaping () -> Void) {
        guard isPinCodeCompleted else { return }
        isEnabledKeyboard = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard self != nil else { return }
            completion()
        }
    }
    
    func removeLastNumber() {
        if !pinCode.isEmpty {
            pinCode.removeLast()
            pinView.indicatorValue -= 1
        }
    }
    
    func updatePinCode(number: String) {
        pinCode.append(number)
        pinView.indicatorValue = pinCode.count
    }
    
}

extension PinCodeController: PinCodeKeyBoardViewDelegate {
    @objc func pinCodeKeyboardView(_ keyboard: PinCodeKeyboardView, didSelect number: String) {
        updatePinCode(number: number)
        updateRightButton()
    }
    
    @objc func pinCodeKeyboardViewDidSelectLeftButton(_ keyboard: PinCodeKeyboardView) {}
    
    @objc func pinCodeKeyboardViewDidSelectRightButton(_ keyboard: PinCodeKeyboardView) {
        removeLastNumber()
        updateRightButton()
    }
}

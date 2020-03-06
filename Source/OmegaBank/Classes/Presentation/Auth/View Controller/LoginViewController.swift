//
//  LoginViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 18.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import InputMask
import UIKit

/// Этап аутентификации.
enum LoginState {
    case phone
    case sms(phone: String)
}

final class LoginViewController: UIViewController {
    
    /// Внутренние контсанты.
    private enum Constants {
        static let transitionTime: Double = 0.5
    }

    // MARK: - Private Properties

    @IBOutlet private var inputMaskListener: MaskedTextFieldDelegate!

    /// Телефон в формате 10 цифр ########## без кода страны
    private var rawPhoneNumber: String?
    private var isValid: Bool = false { didSet { enableNextButton() } }

    private var progress: Progress?
    
    /// Состояние контроллера. Либо форма ввода телефона, либо - смс кода.
    private var stage: LoginState { didSet { stageDidChange(animated: true) } }
    
    /// Сервис для логин формы.
    private let loginService: LoginService

    // MARK: - Outlets

    @IBOutlet private var smsCodeTextField: UITextField!
    @IBOutlet private var phoneTextField: UITextField!
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var phoneInputView: UIView!
    @IBOutlet private var smsInputView: UIView!

    // MARK: - Init

    init(loginService: LoginService = ServiceLayer.shared.loginService,
         stage: LoginState = .phone) {
        self.stage = stage
        self.loginService = loginService
        
        super.init(nibName: nil, bundle: nil)

        title = "Sign In"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progress?.cancel()
    }

    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInputMask()
        setupViews()
    }
    
    // MARK: - Action
    
    @objc private func goPhoneStage() {
        stage = .phone
    }

    @objc private func goSmsStage() {
        self.toggleNextButton(isEnabled: false)
        
        guard let phone = rawPhoneNumber else {
            showErrorMessage("Телефон не может быть пустым")
            return
        }
        
        progress = sendPhone(phone)
    }
    
    @objc private func sendSmsCode() {
        guard let code = smsCodeTextField.text else {
            showErrorMessage("Смс код не может быть пустым")
            return
        }
        
        progress = checkSmsCode(code)
    }
    
    // MARK: - Private

    /// Настраиваем Views.
    private func setupViews() {
        stageDidChange(animated: false)
        phoneTextField.delegate = inputMaskListener
        enableNextButton()
    }

    /// Обновляем ViewController при смене стейта
    private func stageDidChange(animated: Bool) {
        switch stage {

        case .phone:
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem.next(target: self, action: #selector(goSmsStage))

            headerTransition(title: "Your Phone", options: [.transitionFlipFromTop], animated: animated)
            inputViewTransition(from: smsInputView, to: phoneInputView, animated: animated)

        case .sms:
            navigationItem.leftBarButtonItem = UIBarButtonItem.back(target: self, action: #selector(goPhoneStage))
            navigationItem.rightBarButtonItem = UIBarButtonItem.next(target: self, action: #selector(sendSmsCode))

            headerTransition(title: "Enter Code", options: [.transitionFlipFromBottom], animated: animated)
            inputViewTransition(from: phoneInputView, to: smsInputView, animated: animated)
        }
    }

    /// Отключаем кнопку Next в случае если это необходимо.
    private func enableNextButton() {
        navigationItem.rightBarButtonItem?.isEnabled = isValid
    }

    /// Анимация при смене этапов аутентификации для поля ввода.
    private func inputViewTransition(from fromView: UIView, to toView: UIView, animated: Bool) {
        toggleNextButton(isEnabled: true)

        guard animated else { return }

        UIView.transition(
            from: fromView,
            to: toView,
            duration: Constants.transitionTime,
            options: [.showHideTransitionViews]
        )
    }

    /// Настраиваем хедер.
    private func headerTransition(title: String, options: UIView.AnimationOptions, animated: Bool) {
        guard animated else {
            headerLabel.text = title
            return
        }

        UIView.transition(
            with: headerLabel,
            duration: Constants.transitionTime,
            options: options,
            animations: { [weak self] in
                self?.headerLabel.text = title
            }
        )
    }

    /// При успешной аутентификации прячем ViewController.
    private func authSucceed() {
        dismiss(animated: true)
    }
    
    /// Отображаем ошибку.
    private func showErrorMessage(_ message: String) {
        let alert = UIAlertController(
            title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        toggleNextButton(isEnabled: true)
    }

    /// Отключаем кнопку Next чтобы избежать случайных запросов на сервер.
    private func toggleNextButton(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    /// Настраиваем маску ввода
    private func setupInputMask() {
        inputMaskListener.affinityCalculationStrategy = .prefix
        inputMaskListener.affineFormats = ["([000]) [000]-[00]-[00]"]
        inputMaskListener.onMaskedTextChangedCallback = { [weak self] textInput, value, complete in
            guard let self = self else { return }
            
            if self.isValid != complete {
                self.isValid = complete
            }

            self.rawPhoneNumber = complete ? value : nil
            self.toggleNextButton(isEnabled: complete)
        }
    }
    
    // MARK: - Service

    private func sendPhone(_ phone: String) -> Progress {
        loginService.sendPhoneNumber(phone: phone) { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
                return
            }
            
            self?.stage = .sms(phone: phone)
        }
    }
    
    private func checkSmsCode(_ smsCode: String) -> Progress {
        loginService.checkSmsCode(smsCode: smsCode) { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
                return
            }
            
            self?.authSucceed()
        }
    }
}

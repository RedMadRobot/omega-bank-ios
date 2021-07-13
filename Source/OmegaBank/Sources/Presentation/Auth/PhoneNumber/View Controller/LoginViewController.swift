//
//  LoginViewController.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 18.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import InputMask
import UIKit


protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDidAuth(_ controller: LoginViewController)
}

final class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?
    
    /// Внутренние константы.
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

    @IBOutlet private var titledCurvedView: TitledCurvedView!
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

        title = "Sign Up"
        navigationItem.title = nil
        tabBarItem.image = #imageLiteral(resourceName: "signin")
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
        
        smsCodeTextField.addTarget(self, action: #selector(smsCodeEditing), for: .editingChanged)
    }
    
    // MARK: - Action
    
    @objc private func goPhoneStage() {
        stage = .phone
    }

    @objc private func goSmsStage() {
        toggleNextButton(isEnabled: false)
        smsCodeTextField.text = ""
        
        guard let phone = rawPhoneNumber else {
            showErrorMessage("Телефон не может быть пустым")
            return
        }
        
        sendPhone(phone)
    }
    
    @objc private func sendSmsCode() {
        guard let code = smsCodeTextField.text else {
            showErrorMessage("Смс код не может быть пустым")
            return
        }
        
        checkSmsCode(code)
    }
    
    // MARK: - Private

    /// Настраиваем Views.
    private func setupViews() {
        stageDidChange(animated: false)
        enableNextButton()
        titledCurvedView.setup(with: title ?? "")
    }
    
    @objc private func smsCodeEditing() {
        isValid = smsCodeTextField.hasText
    }

    /// Обновляем ViewController при смене стейта
    private func stageDidChange(animated: Bool) {
        switch stage {

        case .phone:
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem.next(target: self, action: #selector(goSmsStage))
            navigationItem.rightBarButtonItem?.accessibilityLabel = "next"

            headerTransition(title: "Your Phone", options: [.transitionFlipFromTop], animated: animated)
            inputViewTransition(from: smsInputView, to: phoneInputView, animated: animated)
            
            phoneTextField.becomeFirstResponder()
        case .sms:
            navigationItem.leftBarButtonItem = UIBarButtonItem.back(target: self, action: #selector(goPhoneStage))
            navigationItem.leftBarButtonItem?.accessibilityLabel = "back"
            navigationItem.rightBarButtonItem = UIBarButtonItem.next(target: self, action: #selector(sendSmsCode))
            navigationItem.rightBarButtonItem?.accessibilityLabel = "login"
            navigationItem.rightBarButtonItem?.isEnabled = false

            headerTransition(title: "Enter Code", options: [.transitionFlipFromBottom], animated: animated)
            inputViewTransition(from: phoneInputView, to: smsInputView, animated: animated)
            
            smsCodeTextField.becomeFirstResponder()
        }
    }

    /// Отключаем кнопку Next в случае если это необходимо.
    private func enableNextButton() {
        navigationItem.rightBarButtonItem?.isEnabled = isValid
    }

    /// Анимация при смене этапов аутентификации для поля ввода.
    private func inputViewTransition(from fromView: UIView, to toView: UIView, animated: Bool) {
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
        delegate?.loginViewControllerDidAuth(self)
    }
    
    // or
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
        inputMaskListener.delegate = self
        phoneTextField.delegate = inputMaskListener
        
        inputMaskListener.affinityCalculationStrategy = .prefix
        inputMaskListener.affineFormats = ["([000]) [000]-[00]-[00]"]
    }
    
    // MARK: - Service

    private func sendPhone(_ phone: String) {
        progress = loginService.sendPhoneNumber(phone: phone) { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
                return
            }
            
            self?.stage = .sms(phone: phone)
        }
    }
    
    private func checkSmsCode(_ smsCode: String) {
        progress = loginService.checkSmsCode(smsCode: smsCode) { [weak self] error in
            if let error = error {
                self?.showErrorMessage(error.localizedDescription)
                return
            }
            
            self?.authSucceed()
        }
    }
}

extension LoginViewController: MaskedTextFieldDelegateListener {

    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        guard textField == phoneTextField else { return }

        if self.isValid != complete {
            self.isValid = complete
        }

        self.rawPhoneNumber = complete ? value : nil
        self.toggleNextButton(isEnabled: complete)
    }
}

//
//  LoginViewModel.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

final class LoginViewModel: ObservableObject {
    
    private let loginService: LoginService
    private var progress: Progress?
    
    @Published var stage: LoginState = .phone
    @Published var phone: String = ""
    var thePhone: String {
        set(newValue) {
            var mutatingPhone = newValue
                .applyPatternOnNumbers(pattern: "(###) ###-##-##", replacementCharacter: "#")
            let chars = newValue.count - 15
            mutatingPhone.removeLast(chars >= 0 ? chars : 0 )
            phone = mutatingPhone
        }
        get {
            return phone
        }
    }
    @Published var code: String = ""
    @Published var error: String? = nil
    @Published var hasError: Bool = false
    
    init(service: LoginService = ServiceLayer.shared.loginService) {
        self.loginService = service
    }
    
    var isEnabled: Bool {
        switch stage {
        case .phone:
            return phone.count > 6
        case .sms(_):
            return code.count > 3
        }
    }
    
    var isPhoneValid: Bool {
        return phone.count < 7
    }
    
    var isCodeValid: Bool {
        return code.count < 5
    }
    
    var trailingButtonTitle: String {
        switch stage {
        case .phone:
            return "Next"
        case .sms(_):
            return "Login"
        }
    }
    
    func sendPhone() {
        progress = loginService.sendPhoneNumber(phone: phone) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.hasError = true
                self.error = error.localizedDescription
                return
            }
            
            self.stage = .sms(phone: self.phone)
        }
    }
    
    func sendCode() {
        progress = loginService.checkSmsCode(smsCode: code) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.hasError = true
                self.error = error.localizedDescription
                return
            }
            
            //self?.authSucceed()
        }
    }
    
    func goNextStage() {
        switch stage {
        case .phone:
            sendPhone()
        case .sms(_):
            sendCode()
        }
    }
    
    func goBack() {
        stage = .phone
    }
    
    deinit {
        progress?.cancel()
    }
}

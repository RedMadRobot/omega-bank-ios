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
    
    @Published var stage: LoginState = .phone
    @Published var phone: String = ""
    @Published var code: String = ""
    
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
    
    func goNextStage() {
        if stage == .phone {
            stage = .sms(phone: phone)
        } else {
            // TODO
        }
    }
    
    func goBack() {
        stage = .phone
    }
}

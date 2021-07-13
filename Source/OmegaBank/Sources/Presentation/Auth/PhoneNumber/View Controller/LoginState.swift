//
//  LoginState.swift
//  OmegaBank
//
//  Created by Anna Kocheshkova on 12.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

/// Этап аутентификации.
enum LoginState: Equatable {
    case phone
    case sms(phone: String)
}

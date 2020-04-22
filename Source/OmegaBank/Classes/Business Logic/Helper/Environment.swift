//
//  Environment.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/17/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

/// Переменные окружения. Берутся из аргументов запуска
final class Environment {
    
    static var isUnitTesting: Bool { UserDefaults.standard.bool(forKey: "ui_testing") }
    
    static var shouldSkipAuth: Bool { UserDefaults.standard.bool(forKey: "skip_auth") }

}

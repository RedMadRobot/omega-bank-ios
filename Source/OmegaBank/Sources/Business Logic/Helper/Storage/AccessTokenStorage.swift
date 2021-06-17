//
//  AccessTokenStorage.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

import LocalAuthentication

enum AccessTokenStorageProperties {
    static let accessTokenKey = "ru.rt.omegabank.accessToken"
    static let pinCode = "ru.rt.omegabank.pinCode"
    static let pinCodeFlag = "ru.rt.omegabank.pinCodeFlag"
    static let biometricSystemPermission = "ru.rt.omegabank.biometricSystemPermission"
}

/// Хранилище токена доступа.
protocol AccessTokenStorage: AnyObject {

    /// Текущий токен доступа.
    var accessToken: String? { get }
    
    /// Создал ли пользователь пин-код
    var hasUserPinCode: Bool { get }
    
    /// Отображался ли системный алерт биометрии
    var hasBiometricSystemMessage: Bool { get }
    
    /// Установил ли пользователь биометрию на пин-код
    var hasUserBiometricEntry: Bool { get }
    
    /// Получение пин-кода
    func getPinCode(withBiometry context: LAContext) throws -> String?
    
    /// Получение токен доступа
    func getToken(_ pinCode: String) throws -> String?
    
    /// Запись пин-кода
    func set(pinCode: String) throws
    
    /// Запись токен доступа по пин-коду
    func set(token: String, by pinCode: String) throws
    
    /// Запись флага, что пользователь установил пароль
    func set(userHasPinCode: Bool) throws
    
    /// Запись флага, что пользователю отобразился системный алерт на биометрию
    func set(biometricSystemPermission: Bool) throws
    
    /// Удаление пин-кода и токена
    func cleanStorage()
    
}

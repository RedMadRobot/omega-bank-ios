//
//  LoginService.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

import LocalAuthentication
import OmegaBankAPI

typealias AuthCompletionHandler = (Error?) -> Void

/// Сервис авторизации.
protocol LoginService {
    
    /// Авторизован ли пользователь.
    var isAuthorized: Bool { get }
    
    /// Отображался ли системный алерт биометрии
    var hasBiometricPermission: Bool { get }
    
    /// Есть ли вход по биометрии
    var hasBiometricEntry: Bool { get }
    
    /// Типы биометрии на устройстве
    var biometricType: LABiometryType { get }
    
    /// Обновить статус авторизации и параметры подключения.
    func restore()
    
    /// Регистрация телефонного номера.
    func sendPhoneNumber(phone: String, completionHandler: @escaping AuthCompletionHandler) -> Progress
    
    /// Проверка sms кода, получение access_token и refresh_token.
    func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress
    
    /// Сохранение токена
    func setToken(by pinCode: String) throws 
    
    /// Сохранение токена по биометрии
    func setTokenWithBiometry(by pinCode: String) throws
    
    /// Вход по пин-коду
    func authorise(by pinCode: String) throws
    
    /// Вход по биометрии
    func authoriseWithBiometry(completion: @escaping BiometricHandler)
    
    /// Вызов метода биометрии evaluateAccessControl
    func evaluateBiometry(reason: String, completion: @escaping BiometricHandler)
    
    /// Запись флага на отображение системного алерта
    func set(biometricSystemPermission: Bool) throws
    
    /// Деавторизация
    func logOut()
}

/// Сервис авторизации.
final class AuthService {
    
    // MARK: - Public Properties
    
    var tokenInvalidHandler: VoidClosure?
    
    // MARK: - Private Properties
    
    private let biometricService: BiometricService
    
    private var apiClient: ApiClient
    private let accessTokenStorage: AccessTokenStorage
    private let baseURL: () -> URL
    
    private var token: String?
    
    init(
        biometricService: BiometricService,
        apiClient: ApiClient,
        accessTokenStorage: AccessTokenStorage,
        baseURL: @escaping () -> URL) {
        
        self.biometricService = biometricService
        
        self.apiClient = apiClient
        self.accessTokenStorage = accessTokenStorage
        self.baseURL = baseURL
        
        self.apiClient.tokenInvalidHandler = { [weak self] in
            self?.logOut()
            self?.tokenInvalidHandler?()
        }
    }
    
    // MARK: - Private
    
    /// Передача token доступа в Api сервис после создания пин-кода/ входа по пин-коду
    private func refreshApiToken() {
        self.apiClient.accessToken = token
    }
}

// MARK: - LoginService

extension AuthService: LoginService {
    
    /// Авторизован ли пользователь.
    var isAuthorized: Bool {
        accessTokenStorage.hasUserPinCode
    }
    
    /// Отображался ли системный алерт биометрии
    var hasBiometricPermission: Bool {
        guard biometricService.biometricState == .available else {
            return false }
        return accessTokenStorage.hasBiometricSystemMessage
    }
    
    // Есть ли вход по биометрии
    var hasBiometricEntry: Bool {
        accessTokenStorage.hasUserBiometricEntry
    }
    
    /// Тип биометрии на ус-ве
    var biometricType: LABiometryType {
        biometricService.checkBiometricType()
    }
    
    /// Регистрация пользователя по номеру телефона.
    @discardableResult
    func sendPhoneNumber(phone: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        let endpoint = SendPhoneEndpoint(phone: phone)
        
        return apiClient.request(endpoint) { result in
            switch result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
    
    /// Получение  access_token по номеру телефона.
    @discardableResult
    func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        let endpoint = CheckSmsCodeEndpoint(smsCode: smsCode)
        
        return apiClient.request(endpoint) { [weak self] result in
            guard let self = self else { return }
            
            do {
                let token = try result.get().accessToken
                self.token = token
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }
    
    /// Сохранение токена по пин-коду и добавление его в ApiClient
    func setToken(by pinCode: String) throws {
        do {
            if let token = token {
                try accessTokenStorage.set(token: token, by: pinCode)
                refreshApiToken()
            }
        } catch {
            throw error
        }
    }
    
    /// Сохранение токена и пин-кода для биометрии
    func setTokenWithBiometry(by pinCode: String) throws {
        try setToken(by: pinCode)
        try accessTokenStorage.set(pinCode: pinCode)
    }
    
    /// Авторизация по пин-коду
    func authorise(by pinCode: String) throws {
        token = try accessTokenStorage.getToken(pinCode)
        refreshApiToken()
    }
    
    /// Авторизация по биометрии
    func authoriseWithBiometry(completion: @escaping BiometricHandler) {
        biometricService.evaluateContextWithBiometryAccess(
            reason: "Please authenticate yourself"
        ) { [weak self] result in
            guard let self = self else { return }
            
            try? self.set(biometricSystemPermission: true)
            
            switch result {
            case .success(let context):
                do {
                    if let pinCode = try self.accessTokenStorage.getPinCode(withBiometry: context) {
                        try self.authorise(by: pinCode)
                        completion(.success(context))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Запуск метода биометрии evaluateAccessControl
    func evaluateBiometry(reason: String, completion: @escaping BiometricHandler) {
        biometricService.evaluateContextWithBiometryAccess(reason: reason, completion: completion)
    }
    
    /// Запись флага на отображение системного алерта
    func set(biometricSystemPermission flag: Bool) throws {
        try accessTokenStorage.set(biometricSystemPermission: flag)
    }
    
    /// Деавторизация
    func logOut() {
        accessTokenStorage.cleanStorage()
    }
    
    /// Обновить статус авторизации и параметры подключения.
    func restore() {
        apiClient.accessToken = accessTokenStorage.accessToken
        apiClient.baseURL = baseURL()
    }
}

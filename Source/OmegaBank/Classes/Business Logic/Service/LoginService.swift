//
//  LoginService.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

import Foundation
import OmegaBankAPI

public typealias AuthCompletionHandler = (Error?) -> Void

/// Сервис авторизации.
public protocol LoginService {

    /// Авторизован ли пользователь.
    var isAuthorized: Bool { get }

    /// Обновить статус авторизации и параметры подключения.
    func restore()
    
    /// Регистрация телефонного номера.
    func sendPhoneNumber(phone: String, completionHandler: @escaping AuthCompletionHandler) -> Progress
    
    /// Проверка sms кода, получение access_token и refresh_token.
    func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress

}

/// Сервис авторизации.
public final class AuthService {

    private var apiClient: ApiClient
    private let accessTokenStorage: AccessTokenStorage
    private let baseURL: () -> URL

    public var tokenInvalidHandler: (() -> Void)?
    
    public init(apiClient: ApiClient, accessTokenStorage: AccessTokenStorage, baseURL: @escaping () -> URL) {

        self.apiClient = apiClient
        self.accessTokenStorage = accessTokenStorage
        self.apiClient.accessToken = accessTokenStorage.accessToken
        self.baseURL = baseURL

        self.apiClient.tokenInvalidHandler = { [weak self] in
            try? self?.setToken(nil)
            self?.tokenInvalidHandler?()
        }
    }

    // MARK: - Private

    private func setToken(_ token: String?) throws {
        try accessTokenStorage.setAccessToken(token)
        apiClient.accessToken = token
    }
}

// MARK: - LoginService

extension AuthService: LoginService {

    /// Регистрация пользователя по номеру телефона.
    @discardableResult
    public func sendPhoneNumber(phone: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        let endpoint = SendPhoneEndpoint(phone: phone)

        return apiClient.request(endpoint) { _ in
            completionHandler(nil)
        }
    }
    
    /// Получение  access_token по номеру телефона.
    public func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
        
        let endpoint = CheckSmsCodeEndpoint(smsCode: smsCode)
        
        return apiClient.request(endpoint) { [weak self] result in
            do {
                let token = try result.get().accessToken
                try self?.setToken(token)
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }

    /// Авторизован ли пользователь.
    public var isAuthorized: Bool {
        accessTokenStorage.accessToken != nil
    }

    /// Обновить статус авторизации и параметры подключения.
    public func restore() {
        apiClient.accessToken = accessTokenStorage.accessToken
        apiClient.baseURL = baseURL()
    }
}

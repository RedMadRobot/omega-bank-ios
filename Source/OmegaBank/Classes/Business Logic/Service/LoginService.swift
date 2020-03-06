//
//  LoginService.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

import Foundation
import OmegaBankAPI

typealias AuthCompletionHandler = (Error?) -> Void

/// Сервис авторизации.
protocol LoginService {

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
final class AuthService {

    private var apiClient: ApiClient
    private let accessTokenStorage: AccessTokenStorage
    private let baseURL: () -> URL

    var tokenInvalidHandler: (() -> Void)?
    
    init(apiClient: ApiClient, accessTokenStorage: AccessTokenStorage, baseURL: @escaping () -> URL) {

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
    func checkSmsCode(smsCode: String, completionHandler: @escaping AuthCompletionHandler) -> Progress {
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
    var isAuthorized: Bool {
        accessTokenStorage.accessToken != nil
    }

    /// Обновить статус авторизации и параметры подключения.
    func restore() {
        apiClient.accessToken = accessTokenStorage.accessToken
        apiClient.baseURL = baseURL()
    }
}

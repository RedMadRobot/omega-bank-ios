//
//  ServiceLayer.swift
//  OmegaBank
//
//  Created by Code Generator.
//  Copyright © 2020 Redmadrobot. All rights reserved.
//

import Foundation
import OmegaBankAPI

extension Bundle {
    var appBundleId: String {
        // swiftlint:disable:next force_cast
        return object(forInfoDictionaryKey: "APP_BUNDLE_IDENTIFIER") as! String
    }

    var appIdentifierPrefix: String {
        // swiftlint:disable:next force_cast
        return object(forInfoDictionaryKey: "APP_IDENTIFIER_PREFIX") as! String
    }
}

final class ServiceLayer {
    static let shared = ServiceLayer()
    
    // MARK: - Private Properties
    
    private var bundle: Bundle { Bundle.main }
    private var userDefaults: UserDefaults { UserDefaults.standard }
    private lazy var baseURL = BaseURL(bundle: bundle)

    private lazy var keychainStorage: KeychainStorage = {
        let storage = KeychainStorage(
            service: "ru.rt.omegabank",
            accessGroup: "\(self.bundle.appIdentifierPrefix).ru.rt.key.keychain_sharing",
            flagStorage: self.userDefaults)
        return storage
    }()
    
    /// Общий сервис авторизации
    private lazy var authService = AuthService(
        apiClient: apiClient,
        accessTokenStorage: keychainStorage,
        baseURL: fetchBaseURL)
    
    // MARK: - Public Properties
    
    /// Сервис авторизации.
    var loginService: LoginService { authService }

    private(set) lazy var apiClient: ApiClient = {
        OmegaBankAPI.Client(
            baseURL: fetchBaseURL(),
            responseObserver: {  _, _, _, error in
                guard let error = error else { return }
                // логируем ошибки.
            })
    }()
    
    struct BaseURL {
        let bundle: Bundle

        func fetch() -> URL {
            // URL из Info.plist swiftlint:disable:next force_cast
            let string = (bundle.object(forInfoDictionaryKey: "API_BASE_URL") as! String)
                .replacingOccurrences(of: "\\", with: "") // Убрираем экранирующие символы

            return URL(string: string)!
        }
    }
    
    private func fetchBaseURL() -> URL {
        let url = baseURL.fetch()

        return url
    }
}

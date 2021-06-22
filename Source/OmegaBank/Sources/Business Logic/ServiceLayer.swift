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
            flagStorage: self.userDefaults)
        
        #if DEBUG        
        if Environment.isUnitTesting {
            if Environment.shouldSkipAuth {
                try? storage.setAccessToken("123")
            } else {
                try? storage.setAccessToken(nil)
            }
        }
        #endif
        
        return storage
    }()

    // MARK: - Public Properties
    
    /// Сервис авторизации.
    private(set) lazy var loginService = AuthService(
        biometricService: biometricService,
        apiClient: apiClient,
        accessTokenStorage: keychainStorage,
        baseURL: baseURL.fetch)
    
    /// Сервис биометрии
    private(set) lazy var biometricService = BiometricServiceImpl()

    /// Сервис партнеров
    private(set) lazy var partnerListService = PartnerListServiceImpl(apiClient: apiClient)
    
    /// Сервис работы с картами
    private(set) lazy var cardListService = CardListServiceImpl(apiClient: apiClient)
    
    /// Сервис работы с депозитами
    private(set) lazy var depositListService = DepositListImpl(apiClient: apiClient)

    private(set) lazy var apiClient: ApiClient = {
        OmegaBankAPI.Client(
            baseURL: baseURL.fetch(),
            responseObserver: {  _, _, _, error in
                guard let error = error else { return }
                // логируем ошибки.
            })
    }()
    
    struct BaseURL {
        let bundle: Bundle

        func fetch() -> URL {
            let urlKey = "API_BASE_URL"
            // URL из Info.plist swiftlint:disable:next force_cast
            var string = (bundle.object(forInfoDictionaryKey: urlKey) as! String)
                .replacingOccurrences(of: "\\", with: "") // Убрираем экранирующие символы
            
            #if DEBUG
            if let urlFromEnvironment = UserDefaults.standard.string(forKey: urlKey) {
                string = urlFromEnvironment
            }
            #endif

            return URL(string: string)!
        }
    }
    
}

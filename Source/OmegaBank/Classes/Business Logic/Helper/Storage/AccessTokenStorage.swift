//
//  AccessTokenStorage.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

import Foundation

enum AccessTokenStorageProperties {
    static let accessTokenKey = "ru.rt.omegabank.accessToken"
}

/// Хранилище токена доступа.
protocol AccessTokenStorage: AnyObject {

    /// Текущий токен доступа.
    var accessToken: String? { get }

    /// Установить токен доступа.
    ///
    /// - Parameter token: Новый токен доступа.
    /// - Throws: Ошибка сохранения.
    func setAccessToken(_ token: String?) throws
}

extension KeychainStorage: AccessTokenStorage {

    var accessToken: String? {
        try? data(for: AccessTokenStorageProperties.accessTokenKey)
            .flatMap { String(data: $0, encoding: .utf8) }
    }

    func setAccessToken(_ token: String?) throws {
        let data = token.map { Data($0.utf8) }
        try set(data, for: AccessTokenStorageProperties.accessTokenKey)
    }
}

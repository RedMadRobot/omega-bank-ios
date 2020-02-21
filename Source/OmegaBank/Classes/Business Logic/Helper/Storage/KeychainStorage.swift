//
//  KeychainStorage.swift
//  OmegaBank
//
//  Created by Alexander Ignatev on 15/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation
import KeychainAccess

/// Хранилище данных в `Keychain`.
public final class KeychainStorage {

    private static let keychainCleaned = "ru.rt.omegabank.key.isKeychainCleaned"

    private let keychain: Keychain

    public init(service: String, accessGroup: String, flagStorage: BoolStorage) {
        keychain = Keychain(service: service, accessGroup: accessGroup)

        // При удалении приложения Keychain сбрасывается не сразу. Чистим принудительно
        if !flagStorage.bool(forKey: KeychainStorage.keychainCleaned) {
            try? keychain.removeAll()
            flagStorage.set(true, forKey: KeychainStorage.keychainCleaned)
        }
    }
}

// MARK: - DataStorage

extension KeychainStorage: DataStorage {

    public func set(_ data: Data?, for key: String) throws {
        if let data = data {
            try keychain.set(data, key: key)
        } else {
            try keychain.remove(key)
        }
    }

    public func data(for key: String) throws -> Data? {
        try keychain.getData(key)
    }
}

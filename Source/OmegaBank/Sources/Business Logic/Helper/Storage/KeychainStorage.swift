//
//  KeychainStorage.swift
//  OmegaBank
//
//  Created by Alexander Ignatev on 15/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation
import KeychainAccess
import LocalAuthentication

/// Хранилище данных в `Keychain`.
final class KeychainStorage {

    private static let keychainCleaned = "ru.rt.omegabank.key.isKeychainCleaned"

    private let keychain: Keychain
    
    private var token: String?

    init(service: String, accessGroup: String, flagStorage: BoolStorage) {
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

    func set(_ data: Data?, for key: String) throws {
        if let data = data {
            try keychain.set(data, key: key)
        } else {
            try keychain.remove(key)
        }
    }

    func data(for key: String) throws -> Data? {
        try keychain.getData(key)
    }
}

// MARK: - AccessTokenStorage

extension KeychainStorage: AccessTokenStorage {
    
    var accessToken: String? {
        token
    }
    
    var hasUserPinCode: Bool {
        let stringValue = (try? keychain.get(AccessTokenStorageProperties.pinCodeFlag)) ?? "false"
        guard let value = Bool(stringValue) else { return false }
        return value
    }
    
    var hasBiometricSystemMessage: Bool {
        let stringValue = (try? keychain.get(AccessTokenStorageProperties.biometricSystemPermission)) ?? "false"
        guard let value = Bool(stringValue) else { return false }
        return value
    }
    
    var hasUserBiometricEntry: Bool {
        (try? keychain.contains(AccessTokenStorageProperties.pinCode, withoutAuthenticationUI: true)) ?? false
    }
    
    func getPinCode(withBiometry context: LAContext) throws -> String? {
        let keychain = keychain.authenticationContext(context)
        return try keychain.get(AccessTokenStorageProperties.pinCode)
    }
    
    func getToken(_ pinCode: String) throws -> String? {
        let context = LAContext()
        context.setCredential(Data(pinCode.utf8), type: .applicationPassword)
        let keychain = keychain.authenticationContext(context)
        token = try keychain.get(AccessTokenStorageProperties.accessTokenKey)
        return token
    }
    
    func set(pinCode: String) throws {
        try keychain.remove(AccessTokenStorageProperties.pinCode)
        
        let keychain = keychain.accessibility(
            .whenUnlockedThisDeviceOnly,
            authenticationPolicy: [.biometryCurrentSet])
        try keychain.set(pinCode, key: AccessTokenStorageProperties.pinCode)
    }
    
    func set(token: String, by pinCode: String) throws {
        let context = LAContext()
        context.setCredential(pinCode.data(using: .utf8), type: .applicationPassword)
        let keychain = keychain.authenticationContext(context)
            .accessibility(
                .whenUnlockedThisDeviceOnly,
                authenticationPolicy: [.applicationPassword])
        
        try set(userHasPinCode: true)
        
        do {
            try keychain.set(token, key: AccessTokenStorageProperties.accessTokenKey)
        } catch {
            try keychain.remove(AccessTokenStorageProperties.accessTokenKey)
        }
        
    }
    
    func set(userHasPinCode flag: Bool) throws {
        let string = String(flag)
        do {
            try keychain.set(string, key: AccessTokenStorageProperties.pinCodeFlag)
        } catch {
            try keychain.remove(AccessTokenStorageProperties.pinCodeFlag)
        }
    }
    
    func set(biometricSystemPermission flag: Bool) throws {
        let string = String(flag)
        do {
            try keychain.set(string, key: AccessTokenStorageProperties.biometricSystemPermission)
        } catch {
            try keychain.remove(AccessTokenStorageProperties.biometricSystemPermission)
        }
    }
    
    func cleanStorage() {
        token = nil
        try? keychain.remove(AccessTokenStorageProperties.pinCodeFlag)
        try? keychain.remove(AccessTokenStorageProperties.pinCode)
        try? keychain.remove(AccessTokenStorageProperties.accessTokenKey)
    }
}

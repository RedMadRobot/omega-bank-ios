//
//  BiometricService.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 15.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import LocalAuthentication

protocol BiometricService {
    
    /// Доступ к биометрии: Доступна/Нет доступа/Запрещена
    var biometricState: BiometricState { get }
    
    /// Возвращает тип биометрии
    func checkBiometricType() -> LABiometryType
    
    /// Выполняет проверку биометрии и получается context для доступа в Keychain
    func evaluateContextWithBiometryAccess(
        reason: String,
        completion: @escaping (Swift.Result<LAContext, Error>
        ) throws -> Void)
}

enum BiometricState {
    case available, locked, notAvailable
}

final class BiometricServiceImpl: BiometricService {
    
    var biometricState: BiometricState {
        let context = LAContext()
        var error: NSError?
        
        let biometryAvailable = context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error)
        
        return biometryAvailable ? .available : .notAvailable
    }
    
    func checkBiometricType() -> LABiometryType {
        let context = LAContext()
        var error: NSError?
        
        let biometricAvailable = context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error)
        
        if error != nil {
            return .none
        }
        
        if biometricAvailable {
            return biometricState == .available ? context.biometryType : .none
        } else {
            return .none
        }
    }
    
    func evaluateContextWithBiometryAccess(
        reason: String,
        completion: @escaping (Swift.Result<LAContext, Error>
        ) throws -> Void) {
        
        let context = LAContext()
        
        let accessControl: SecAccessControl
        do {
            accessControl = try getBiometrySecAccessControl()
        } catch {
            try? completion(.failure(error))
            return
        }
        
        context.evaluateAccessControl(
            accessControl,
            operation: .useItem,
            localizedReason: reason) { success, error in
            
            DispatchQueue.main.async {
                if success {
                    try? completion(.success(context))
                }
                if let error = error {
                    try? completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getBiometrySecAccessControl() throws -> SecAccessControl {
        var error: Unmanaged<CFError>?
        let access = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .biometryCurrentSet,
            &error)
        if let error = error?.takeUnretainedValue() {
            throw error
        }
        if let access = access {
            return access
        } else {
            preconditionFailure("SecAccessControlCreateWithFlags failed")
        }
    }
    
}

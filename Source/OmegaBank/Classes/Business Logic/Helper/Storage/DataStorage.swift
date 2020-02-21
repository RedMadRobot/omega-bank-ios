//
//  DataStorage.swift
//  OmegaBank
//
//  Created by Alexander Ignatev on 15/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

/// Хранилище бинарных данных.
///
/// Закрывает собой `Keychain` или `UserDefaults`.
public protocol DataStorage: AnyObject {

    /// Сохранение, обновление или удаление данных.
    ///
    /// - Parameters:
    ///   - data: Данные для записи.
    ///   - key: Ключ, с которыми связаны данные.
    /// - Throws: Ошибка сохранения данных.
    func set(_ data: Data?, for key: String) throws

    /// Чтение данных.
    ///
    /// - Parameter key: Ключ, с которыми связаны данные.
    /// - Returns: Сохраненные данные, если есть.
    /// - Throws: Ошибка чтения данных.
    func data(for key: String) throws -> Data?
}

// MARK: - UserDefaults + DataStorage

extension UserDefaults: DataStorage {

    public func set(_ data: Data?, for key: String) throws {
        set(data, forKey: key)
    }

    public func data(for key: String) throws -> Data? {
        data(forKey: key)
    }
}

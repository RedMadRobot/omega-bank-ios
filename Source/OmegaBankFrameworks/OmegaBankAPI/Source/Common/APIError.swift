//
//  APIError.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on 08/02/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

/// Ошибка API.
public struct APIError: Decodable, Error {

    /// Код ошибки.
    public struct Code: RawRepresentable, Decodable, Equatable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }

    /// Код ошибки.
    public let code: Code

    /// Заголовок ошибки.
    public let title: String?

    /// Описание ошибки.
    public let description: String?

    /// Инетревал в секундах, через который можно будет повторить операцию.
    public var retryAfter: TimeInterval?

    public init(
        code: Code,
        title: String? = nil,
        description: String? = nil,
        retryAfter: TimeInterval? = nil) {

        self.code = code
        self.title = title
        self.description = description
        self.retryAfter = retryAfter
    }
}

// MARK: - General Error Codes

extension APIError.Code {
    /// Некорректный токен.
    public static let tokenInvalid = APIError.Code("token_invalid")
}

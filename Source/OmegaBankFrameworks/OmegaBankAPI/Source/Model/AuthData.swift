//
//  AuthData.swift
//  OmegaBankAPI
//
//  Created by Nikolai Zhukov on 17.02.2020.
//

/// Авторизационные данные.
public struct AuthData: Decodable, Equatable {
    /// Токен доступа.
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

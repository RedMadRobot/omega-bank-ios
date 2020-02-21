//
//  APIService.swift
//  OmegaBank
//
//  Created by Alexander Ignatev on 22/02/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.

import Foundation

/// API клиент для авторизации.
public protocol ApiClient {

    /// Токен доступа.
    var accessToken: String? { get set }

    /// Базовый `URL`.
    var baseURL: URL { get set }

    var tokenInvalidHandler: (() -> Void)? { get set }

    @discardableResult
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void) -> Progress where T: Endpoint
}

/// Базовый сервис с API клиентом.
open class APIService {

    /// API клиент.
    public let apiClient: ApiClient

    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
}

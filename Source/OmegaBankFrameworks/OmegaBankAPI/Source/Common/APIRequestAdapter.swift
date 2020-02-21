//
//  APIRequestAdapter.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on on 17.02.2020.
//

import Alamofire
import Foundation

/// Адаптер запросов к API.
public final class APIRequestAdapter: Alamofire.RequestAdapter {

    /// Базовый `URL` API.
    ///
    /// - Warning: Возможность обновления только для отдлаки.
    public var baseURL: URL

    /// Aвторизационный токен.
    ///
    public var accessToken: String?

    /// Создать адаптер с базовым `URL`.
    ///
    /// - Parameter baseURL: Базовый `URL`
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Alamofire.RequestAdapter

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard let url = urlRequest.url else { return urlRequest }

        var request = urlRequest
        request.url = appendingBaseURL(to: url)

        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    // MARK: - Private

    private func appendingBaseURL(to url: URL) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.percentEncodedQuery = url.query
        return components.url!.appendingPathComponent(url.path)
    }
}

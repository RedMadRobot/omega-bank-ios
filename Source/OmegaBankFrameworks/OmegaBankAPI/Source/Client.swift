//
//  Client.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on on 17.02.2020.
//

import Alamofire
import Foundation

public typealias APIResult<Value> = Swift.Result<Value, Error>

/// Клиент для работы со Omega bank API.
public final class Client: ApiClient {
    
    public typealias ResponseObserver = (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Void
    
    /// Менеджер сетевой сессии.
    private let sessionManager: Alamofire.SessionManager
    
    /// Очередь ответов сервера.
    private let responseQueue = DispatchQueue(
        label: "OmegaBankAPI.Client.responseQueue",
        qos: .utility)
    
    /// Очередь колбеков с результатом.
    private let completionQueue: DispatchQueue
    
    /// Наблюдатель за всеми ответами API.
    private let responseObserver: ResponseObserver?
    
    /// Конфигурация сессии.
    private var urlSessionConfiguration: URLSessionConfiguration!
    
    /// Адаптер запросов.
    public let requestAdapter: APIRequestAdapter
    
    public var tokenInvalidHandler: (() -> Void)?
    
    /// Токен доступа.
    public var accessToken: String? {
        get { requestAdapter.accessToken }
        set { requestAdapter.accessToken = newValue }
    }

    /// Базовый `URL`.
    public var baseURL: URL {
        get { requestAdapter.baseURL }
        set { requestAdapter.baseURL = newValue }
    }
    
    /// Создать нового клиента API.
    ///
    /// - Parameters:
    ///   - baseURL: Базовый `URL` API.
    ///   - configuration: Конфигурация сетевой сессии.
    ///   - completionQueue: Очередь колбеков с результатом.
    ///   - responseObserver: Наблюдатель за всеми ответами API.
    public init(
        baseURL: URL,
        completionQueue: DispatchQueue = .main,
        responseObserver: ResponseObserver? = nil) {
        
        let securityManager = ServerTrustPolicyManager(policies: [:])
        
        self.completionQueue = completionQueue
        requestAdapter = APIRequestAdapter(baseURL: baseURL)
        
        urlSessionConfiguration = {
            let config = URLSessionConfiguration.ephemeral
            config.timeoutIntervalForRequest = 30.0
            return config
        }()
        
        sessionManager = SessionManager(
            configuration: urlSessionConfiguration,
            serverTrustPolicyManager: securityManager)
        
        sessionManager.adapter = requestAdapter
        self.responseObserver = responseObserver
    }
    
    /// Отправить запрос к API.
    ///
    /// - Parameters:
    ///   - endpoint: Конечная точка запроса.
    ///   - completionHandler: Обработчик результата запроса.
    /// - Returns: Прогресс выполнения запроса.
    public func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void) -> Progress where T: Endpoint {
        
        let anyRequest = AnyRequest(create: endpoint.makeRequest)
        let request = sessionManager.request(anyRequest).responseData(
            queue: responseQueue,
            completionHandler: { (response: DataResponse<Data>) in
                
                let result = APIResult<T.Content>(catching: { () throws -> T.Content in
                    let data = try response.result.unwrap()
                    return try endpoint.content(from: response.response, with: data)
                })
                
                self.completionQueue.async { [weak self] in
                    
                    if let error = result.error as? APIError, error.code == .tokenInvalid {
                        self?.tokenInvalidHandler?()
                    }
                    
                    self?.responseObserver?(response.request, response.response, response.data, result.error)
                    completionHandler(result)
                }
            })
        
        return progress(for: request)
    }
    
    // MARK: - Private
    
    private func progress(for request: Alamofire.Request) -> Progress {
        let progress = Progress()
        progress.cancellationHandler = request.cancel
        return progress
    }
    
}

// MARK: - Helper

/// Обёртка над протоколом `URLRequestConvertible` из `Alamofire`.
private struct AnyRequest: Alamofire.URLRequestConvertible {
    let create: () throws -> URLRequest
    
    func asURLRequest() throws -> URLRequest {
        try create()
    }
}

private extension APIResult {
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

//
//  MockClient.swift
//  OmegaBankTests
//
//  Created by Nikolay Zhukov on 3/31/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation
import OmegaBankAPI

private final class EndpointHandler {
    var endpoint: Any!
    var errorHandler: (Error) -> Void = { _ in }
    var responseHandler: (Any) -> Void = { _ in }
}

final class MockClient: ApiClient {

    private var endpointHandlers: [EndpointHandler] = []

    var numberOfRequests: Int { endpointHandlers.count }

    var tokenInvalidHandler: (() -> Void)?

    var progress = Progress()

    func fail<E>(_ type: E.Type, with error: Error) -> E? where E: Endpoint {
        for (index, handler) in endpointHandlers.enumerated() where handler.endpoint is E {
            handler.errorHandler(error)
            endpointHandlers.remove(at: index)
            return handler.endpoint as? E
        }
        return nil
    }

    func fulfil<E, T>(_ type: E.Type, with value: T) -> E? where E: Endpoint, T == E.Content {
        for (index, handler) in endpointHandlers.enumerated() where handler.endpoint is E {
            handler.responseHandler(APIResult.success(value))
            endpointHandlers.remove(at: index)
            return handler.endpoint as? E
        }
        return nil
    }

    // MARK: - AuthClinet

    var accessToken: String?
    var baseURL = URL(string: "/")!

    @discardableResult
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void) -> Progress where T: Endpoint {

        let handler = EndpointHandler()
        handler.endpoint = endpoint
        handler.errorHandler = { (error: Error) in
            completionHandler(APIResult<T.Content>.failure(error))
        }
        handler.responseHandler = { (value: Any) in
            completionHandler(value as! APIResult<T.Content>) // swiftlint:disable:this force_cast
        }
        endpointHandlers.append(handler)
        return progress
    }
}

//
//  BaseEndpoint.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on 08/02/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

/// Base Endpoint for application remote resource.
///
/// Contains shared logic for all endpoints in app.
protocol JsonEndpoint: Endpoint where Content: Decodable {
}

extension JsonEndpoint {
    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        
        try ResponseValidator.validate(response, with: body)
        let value = try JSONDecoder.default.decode(ResponseData<Content>.self, from: body)
        return value.data
    }
}

// MARK: - Response

private struct ResponseData<Content>: Decodable where Content: Decodable {
    let data: Content
}

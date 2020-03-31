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
    associatedtype Root: Decodable = Content

    func content(from root: Root) -> Content
}

extension JsonEndpoint {

    public func content(from response: URLResponse?, with body: Data) throws -> Content {
        try ResponseValidator.validate(response, with: body)
        let root = try JSONDecoder.default.decode(ResponseData<Root>.self, from: body)

        return content(from: root.data)
    }
}

// MARK: - Response

private struct ResponseData<Content>: Decodable where Content: Decodable {
    let data: Content
}

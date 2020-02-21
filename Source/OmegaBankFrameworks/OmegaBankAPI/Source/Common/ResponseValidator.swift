//
//  ResponseValidator.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on 19/03/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

private struct ResponseError: Decodable {
    let error: APIError
}

/// Response validation helper.
internal enum ResponseValidator {

    /// Error response validation.
    ///
    /// - Parameters:
    ///   - response: The metadata associated with the response.
    ///   - body: The response body.
    /// - Throws: `APIError`.
    internal static func validate(_ response: URLResponse?, with body: Data) throws {
        try validateHTTPstatus(response)
    }

    private static func validateHTTPstatus(_ response: URLResponse?) throws {
        guard let httpResponse = response as? HTTPURLResponse,
            !(200..<300).contains(httpResponse.statusCode) else { return }

        throw HTTPError(statusCode: httpResponse.statusCode, url: httpResponse.url)
    }
}

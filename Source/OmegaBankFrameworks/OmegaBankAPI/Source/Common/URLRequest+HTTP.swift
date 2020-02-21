//
//  URLRequest+HTTP.swift
//  OmegaBankAPI
//
//  Created by Alexander Ignatev on 07/08/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

extension URLRequest {

    static func get(_ url: URL) -> URLRequest {
        URLRequest(url: url)
    }

    static func post(_ url: URL, json: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        if let body = json {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        return request
    }

    static func patch(_ url: URL, json: Data) -> URLRequest {
        var request = post(url, json: json)
        request.httpMethod = "PATCH"
        return request
    }

    static func delete(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }

}

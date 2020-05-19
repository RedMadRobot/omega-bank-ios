//
//  DepositTypesEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct DepositTypesResponse: Decodable {
    let types: [String]
}

/// Получаем список типов счетов.
public struct DepositTypesEndpoint: JsonEndpoint, Encodable {
    
    // MARK: - Initialization
    
    public init() {}

    // MARK: - JsonEndpoint
    
    public typealias Content = [String]

    func content(from root: DepositTypesResponse) -> Content { root.types }

    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "deposit-types")!
        return URLRequest.get(url)
    }
}

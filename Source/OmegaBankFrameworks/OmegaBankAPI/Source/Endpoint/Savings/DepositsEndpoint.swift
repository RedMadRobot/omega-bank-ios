//
//  DepositsEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/12/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct DepositsResponse: Decodable {
    let deposits: [Deposit]
}

/// Получаем список карт.
public struct DepositsEndpoint: JsonEndpoint, Encodable {

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - JsonEndpoint
    
    public typealias Content = [Deposit]

    func content(from root: DepositsResponse) -> Content { root.deposits }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "deposits")!
        return URLRequest.get(url)
    }
}

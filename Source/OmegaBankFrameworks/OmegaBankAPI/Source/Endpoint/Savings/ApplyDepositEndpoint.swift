//
//  ApplyDepositEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/12/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct DepositResponse: Decodable {
    let deposit: Deposit
}

/// Регистрируем новый продукт.
public struct ApplyDepositEndpoint: JsonEndpoint, Encodable {

    // MARK: - Public Properties
    
    public let type: String
    
    // MARK: - Initialization
    
    public init(type: String) {
        self.type = type
    }
    
    // MARK: - JsonEndpoint
    
    public typealias Content = Deposit
    
    func content(from root: DepositResponse) -> Content { root.deposit }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "deposits")!
        return URLRequest.post(url, json: try encoder.encode(self))
    }
    
}

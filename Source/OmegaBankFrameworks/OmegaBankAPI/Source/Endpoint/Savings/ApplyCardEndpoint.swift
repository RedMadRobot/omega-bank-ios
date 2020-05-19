//
//  ApplyCardEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/12/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct CardResponse: Decodable {
    let card: Card
}

/// Регистрируем новый продукт.
public struct ApplyCardEndpoint: JsonEndpoint, Encodable {

    // MARK: - Public Properties
    
    public let type: String
    
    // MARK: - Initialization
    
    public init(type: String) {
        self.type = type
    }
    
    // MARK: - JsonEndpoint
    
    public typealias Content = Card
    
    func content(from root: CardResponse) -> Content { root.card }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "cards")!
        return URLRequest.post(url, json: try encoder.encode(self))
    }
    
}

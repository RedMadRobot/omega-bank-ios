//
//  CardTypesEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct CardTypesResponse: Decodable {
    let types: [String]
}

/// Получаем список типов карт.
public struct CardTypesEndpoint: JsonEndpoint, Encodable {
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - JsonEndpoint

    public typealias Content = [String]

    func content(from root: CardTypesResponse) -> Content { root.types }

    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "card-types")!
        return URLRequest.get(url)
    }
}

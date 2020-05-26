//
//  CardTypeListEndpoint.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/25/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct CardTypesResponse: Decodable {
    let types: [CardInfo]
}

/// Получаем список типов карт.
public struct CardTypesEndpoint: JsonEndpoint, Encodable {

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - JsonEndpoint
    
    public typealias Content = [CardInfo]

    func content(from root: CardTypesResponse) -> Content { root.types }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "card-types")!
        return URLRequest.get(url)
    }
}

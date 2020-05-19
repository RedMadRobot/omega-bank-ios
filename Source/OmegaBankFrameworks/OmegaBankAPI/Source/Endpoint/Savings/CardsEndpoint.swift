//
//  CardsEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolay Zhukov on 5/12/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct CardsResponse: Decodable {
    let cards: [Card]
}

/// Получаем список карт.
public struct CardsEndpoint: JsonEndpoint, Encodable {

    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - JsonEndpoint
    
    public typealias Content = [Card]

    func content(from root: CardsResponse) -> Content { root.cards }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "cards")!
        return URLRequest.get(url)
    }
}

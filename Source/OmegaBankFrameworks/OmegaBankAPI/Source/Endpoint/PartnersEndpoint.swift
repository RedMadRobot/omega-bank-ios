//
//  DepositionPartnersEndpoint.swift
//  OmegaBankAPI
//
//  Created by Nikolai Zhukov on 06.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct PartnersResponse: Decodable {
    let partners: [Partner]
}

/// Получаем список партнеров.
public struct PartnersEndpoint: JsonEndpoint, Encodable {
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - JsonEndpoint

    public typealias Content = [Partner]

    func content(from root: PartnersResponse) -> Content { root.partners }

    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "deposition-partners")!
        return URLRequest.get(url)
    }
}

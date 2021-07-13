//
//  OfficesEndpoint.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

struct OfficesResponse: Decodable {
    let offices: [Office]
}

/// Получаем список офисов
public struct OfficesEndpoint: JsonEndpoint, Encodable {
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - JsonEndpoint
        
    public typealias Content = [Office]
    
    func content(from root: OfficesResponse) -> [Office] { root.offices }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "offices")!
        return URLRequest.get(url)
    }
    
}

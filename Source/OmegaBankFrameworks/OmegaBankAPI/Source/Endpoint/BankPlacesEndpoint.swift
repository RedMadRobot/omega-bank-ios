//
//  BankPlacesEndpoint.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 30.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

/// Получаем список офисов
public struct BankPlacesEndpoint: JsonEndpoint, Encodable {
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - JsonEndpoint
        
    public typealias Content = BankPlaces
    
    func content(from root: BankPlaces) -> BankPlaces { root }
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "offices")!
        return URLRequest.get(url)
    }
    
}

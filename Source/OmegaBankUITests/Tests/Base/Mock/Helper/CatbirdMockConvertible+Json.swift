//
//  CatbirdMockConvertible+Json.swift
//  OmegaBankUITests
//
//  Created by Nikolay Zhukov on 4/15/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Catbird
import Foundation

extension CatbirdMockConvertible {

    /// Берем json из папки.
    
    func json(_ path: String) throws -> Data {
        let url = TestBase.bundle.url(forResource: "Mocks\(path)", withExtension: "json")!
        let data = try Data(contentsOf: url)
        return data
    }
    
}

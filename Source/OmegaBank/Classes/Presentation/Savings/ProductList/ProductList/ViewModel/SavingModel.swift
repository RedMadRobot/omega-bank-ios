//
//  ProductViewModel.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import Foundation

struct ProductViewModel {
    let name: String
    let datailed: String
    let value: String
    var isNegative: Bool = false
    
    static func make(_ product: Product) -> ProductViewModel {
        ProductViewModel(
            name: product.name,
            datailed: product.number,
            value: "$\(product.value)")
    }
    
    static func make(_ transation: Transaction) -> ProductViewModel {
        let isNegative = transation.value < 0
        return ProductViewModel(
            name: transation.name,
            datailed: "Today",
            value: "\(isNegative ? "-" : "+")$\(abs(transation.value))",
            isNegative: isNegative
        )
    }
}

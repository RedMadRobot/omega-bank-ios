//
//  DepositTypeDescriptorViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.DepositInfo

final class ProductTypeDescriptorViewController<T>: StackedViewController where T: ProductInfo {
    
    // MARK: - Public Properties
    
    var productInfo: T? {
        willSet {
            showDepositInfo(newValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func showDepositInfo(_ productInfo: T?) {
        clearArrangedSubviews()

        guard
            let productInfo = productInfo,
            let parameters = productInfo.about else { return }

        for (i, product) in parameters.enumerated() {
            let subtitleView = SubtitleView.make(title: product.caption, value: product.value)
            addArrangedSubview(subtitleView, isAnimated: false)

            let isLast = i == parameters.count - 1
            if !isLast {
                addSeparator(isAnimated: false)
            }
        }
    }
}

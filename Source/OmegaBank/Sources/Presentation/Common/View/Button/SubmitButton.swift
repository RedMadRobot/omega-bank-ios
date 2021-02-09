//
//  SubmitButton.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class SubmitButton: Button {
    
    override var intrinsicContentSize: CGSize { CGSize(width: View.noIntrinsicMetric, height: 50) }
    
    // MARK: - Button

    override func commonInit() {
        super.commonInit()
        
        titleLabel?.font = .buttonTitle
        backgroundColor =  .ph1
        layer.cornerRadius = 3
        
        setTitleColor(.textPrimary, for: .normal)
        setTitleColor(.textPrimary, for: .highlighted)
    }
    
}

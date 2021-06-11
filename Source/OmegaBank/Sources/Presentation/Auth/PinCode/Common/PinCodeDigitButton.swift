//
//  PinCodeDigitButton.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

final class PinCodeDigitButton: PinCodeBaseButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .bar2 : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 36
        backgroundColor = .white
        
        setTitleColor(.ph3, for: .normal)
    }
    
}

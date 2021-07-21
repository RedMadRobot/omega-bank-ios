//
//  PinCodeButton.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 08.06.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

/// Базовая кнопка для пин-код клавиатуры
class PinCodeBaseButton: UIButton {
    
    // MARK: - Types
    
    private enum Constants {
        static let width: Int = 72
        static let height: Int = 72
        static let cornerRadius: CGFloat = 36
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: Constants.width, height: Constants.height)
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
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .defaultBackground
        isExclusiveTouch = true
        
        setTitleColor(.ph3, for: .normal)
        tintColor = .ph3
    }
}

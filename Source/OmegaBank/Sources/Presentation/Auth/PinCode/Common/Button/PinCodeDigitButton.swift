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
            backgroundColor = isHighlighted ? .bar2 : .defaultBackground
        }
    }
    
}

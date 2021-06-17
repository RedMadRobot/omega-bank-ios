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
    override var intrinsicContentSize: CGSize {
        CGSize(width: 72, height: 72)
    }
}

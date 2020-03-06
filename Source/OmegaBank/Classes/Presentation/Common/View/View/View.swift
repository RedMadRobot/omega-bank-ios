//
//  View.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 02.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Базовая вью.
class View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Настройка после инициализации.
    func commonInit() {}
}

class RoundedView: View {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
    }
}

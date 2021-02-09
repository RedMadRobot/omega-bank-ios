//
//  Button.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Базовая кнопка.
class Button: UIButton {

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    /// Настройка после инициализации.
    func commonInit() {
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func tapAction() {
        onTap?()
    }

}

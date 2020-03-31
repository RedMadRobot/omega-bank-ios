//
//  ShadowView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Контейнер с тенью.
final class ShadowView: View {

    override func commonInit() {
        super.commonInit()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        corners = .default
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 3, height: 3)

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 12.0, *) {
            layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0.0 : 0.15
        }
    }
}

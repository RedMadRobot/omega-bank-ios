//
//  ViewCorners.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// Скругления углов у вьюхи.
enum ViewCorners {
    case circular(CGFloat)
    case continuous(CGFloat)

    static let `default` = ViewCorners.continuous(8)
}

extension ViewCorners {
    var radius: CGFloat {
        switch self {
        case .circular(let radius), .continuous(let radius):
            return radius
        }
    }
}

// MARK: - UIView + ViewCorners

extension UIView {
    var corners: ViewCorners {
        get {
            let radius = layer.cornerRadius
            if #available(iOS 13.0, *), layer.cornerCurve == .continuous {
                return .continuous(radius)
            }
            return .circular(radius)
        }
        set {
            if #available(iOS 13.0, *) {
                switch newValue {
                case .circular:
                    layer.cornerCurve = .circular
                case .continuous:
                    layer.cornerCurve = .continuous
                }
            }
            layer.cornerRadius = newValue.radius
        }
    }
}

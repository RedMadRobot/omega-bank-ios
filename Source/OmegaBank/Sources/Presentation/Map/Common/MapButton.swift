//
//  MapButton.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 15.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import UIKit

final class MapButton: UIButton {
    
    // MARK: - Types
    
    private enum Constants {
        static let width: Int = 48
        static let height: Int = 48
    }
    
    // MARK: - Public properties
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: Constants.width, height: Constants.height)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private properties
    
    func commonInit() {
        backgroundColor = .backgroundPrimaryPressed
    }
    
}

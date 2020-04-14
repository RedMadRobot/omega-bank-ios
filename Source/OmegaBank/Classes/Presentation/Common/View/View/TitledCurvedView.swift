//
//  CurvedViewWithTitle.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class TitledCurvedView: CurvedView {
    
    // MARK: - Private properties
    
    private var titleLabel: UILabel!

    // MARK: - Initializers
    
    override func commonInit() {
        super.commonInit()
        
        titleLabel = UILabel()
        titleLabel.font = .header1
        titleLabel.textColor = .textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    // MARK: - Public Methods
    
    func setup(with title: String) {
        titleLabel.text = title
    }
    
}

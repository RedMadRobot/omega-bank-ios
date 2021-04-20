//
//  PartnerDescriptionView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class HotActionView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var actionLabel: UILabel!
    
    // MARK: - HotActionView
    
    override var intrinsicContentSize: CGSize { CGSize(width: 100, height: 50) }
    
    // MARK: - Initializers
    
    static func make() -> HotActionView {
        let view = HotActionView.loadFromNib()
        view.layer.cornerRadius = 3
        
        return view
    }
    
    // MARK: - Public Methods
    
    func setup(title: String, for index: Int) {
        actionLabel.text = title
        backgroundColor = UIColor.palette[index % UIColor.palette.count]
    }
    
}

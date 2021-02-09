//
//  SubtitleView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class SubtitleView: UIView, NibLoadable {

    // MARK: - IBOutlets
    
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: - Initialization
    
    static func make(
        title: String,
        value: String) -> SubtitleView {
        
        let view = SubtitleView.loadFromNib()
        
        view.valueLabel.text = value
        view.titleLabel.text = title
        
        return view
    }
    
}

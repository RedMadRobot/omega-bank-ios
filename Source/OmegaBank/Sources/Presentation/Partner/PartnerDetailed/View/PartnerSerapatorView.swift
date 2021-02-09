//
//  PartnerSerapatorView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/27/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// View разделитель для секций ScrollView.
final class PartnerSerapatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.scrollViewBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

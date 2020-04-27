//
//  ProductHeader.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ProductHeader: UIView, NibLoadable {

    @IBOutlet private var titleLabel: UILabel!
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: View.noIntrinsicMetric, height: 35)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .tableSectionHeader
    }
    
    static func make(title: String) -> ProductHeader {
        let view = ProductHeader.loadFromNib()
        
        view.titleLabel.text = title
        
        return view
    }
}

//
//  PartnerLimitCell.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/24/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class PartnerLimitCell: UICollectionViewCell, NibRepresentable {

    // MARK: - IBOutlets
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    // MARK: - Public Methods
    
    func setup(with viewModel: PartnerDescriptionViewModel, for index: Int) {
        
        headerLabel.text = viewModel.header
        descriptionLabel.text = viewModel.description
        
        backgroundColor = UIColor.palette[index % UIColor.palette.count]
    }
}

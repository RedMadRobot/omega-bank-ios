//
//  ProductCell.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ProductCell: UIControl, NibLoadable {

    // MARK: - IBOutlets
    
    @IBOutlet private var typeImageView: UIImageView!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var onTap: VoidClosure?
    
    // MARK: - Initialization
    
    static func make(
        viewModel: ProductViewModel,
        onTap: VoidClosure? = nil,
        image: UIImage? = nil) -> ProductCell {
        
        let view = ProductCell.loadFromNib()
        
        view.typeImageView.image = image
        view.typeLabel.text = viewModel.name
        view.numberLabel.text = viewModel.datailed
        view.valueLabel.textColor = viewModel.isNegative ? .ph1 : .bar1
        view.valueLabel.text = viewModel.value
        view.onTap = onTap
        
        return view
    }
    
    // MARK: - ProductCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
    }
    
    deinit {
        removeTarget(self, action: nil, for: .allEvents)
    }
    
    // MARK: - Private Methods
    
    @objc private func onTapAction() {
        onTap?()
    }

}

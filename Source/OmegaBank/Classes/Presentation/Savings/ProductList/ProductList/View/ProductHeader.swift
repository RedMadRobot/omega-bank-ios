//
//  ProductHeader.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ProductHeader: UIControl, NibLoadable {
    
    // MARK: - IBOutlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collapedIndicatorImageView: UIImageView!
    
    // MARK: - Public Properties
    
    var isCollapsed = false {
        willSet {
            collapedIndicatorImageView.image = newValue ? #imageLiteral(resourceName: "arrowRight") : #imageLiteral(resourceName: "arrowDown")
        }
    }
    
    // MARK: - Private Properties
    
    private var onTap: (() -> Void)?
    private var onPlusTap: (() -> Void)?

    // MARK: - ProductHeader
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: View.noIntrinsicMetric, height: 35)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .tableSectionHeader
        
        commonInit()
    }
    
    // MARK: - Initialization
    
    static func make(title: String, onTap: @escaping () -> Void, onPlusTap: @escaping () -> Void) -> ProductHeader {
        let view = ProductHeader.loadFromNib()
        
        view.titleLabel.text = title
        view.onTap = onTap
        view.onPlusTap = onPlusTap
        
        return view
    }
    
    deinit {
        removeTarget(self, action: nil, for: .allEvents)
    }
    
    // MARK: - Private Methods
    
    @IBAction private func addButtonPressed(_ sender: Any) {
        onPlusTap?()
    }
        
    private func commonInit() {
        addTarget(self, action: #selector(onTapAction), for: .touchUpInside)
    }

    @objc private func onTapAction() {
        onTap?()
    }

}

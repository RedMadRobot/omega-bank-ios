//
//  DepositTypeView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.DepositInfo

final class DepositTypeView: UIView, NibLoadable {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 5
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    
    static let size = CGSize(width: 242.5, height: 155.0)
    
    // MARK: - Initialization
    
    static func make(
        depositInfo: DepositInfo,
        index: Int) -> DepositTypeView {
        
        let view = DepositTypeView.loadFromNib()
        view.titleLabel.text = depositInfo.name
        view.backgroundColor = UIColor.palette[index % UIColor.palette.count]
        if let description = depositInfo.description {
            view.textView.text = description
        }

        return view
    }
    
    // MARK: - DepositTypeView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = Constants.cornerRadius
        
        titleLabel.font = .body1
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.font = .body2
    }

}

//
//  AddCardViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/29/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class AddCardViewController: StackedViewController {
    
    // MARK: - Private Properties
    
    private let cardImageView = UIImageView(image: #imageLiteral(resourceName: "card"))
    
    private let aboutCardInfo: [CardInfo] = [
        CardInfo(title: "INTRO PURCHASE APR", description: "N/A"),
        CardInfo(title: "REGULAR PURCHASE APR", description: "15.99%-22.99% Variable"),
        CardInfo(title: "INTRO BALANCE TRANSFER APR", description: "N/A"),
        CardInfo(title: "ANNUAL FEE", description: "$0-$99")
    ]
    
    // MARK: - AddCardViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAboutCardInfo()
    }
    
    // MARK: - Private Methods
    
    private func addAboutCardInfo() {
        addCardImage()
        addCardInfo()
    }
    
    private func addCardImage() {
        cardImageView.contentMode = .scaleAspectFit
        addArrangedSubview(cardImageView)
    }
    
    private func addCardInfo() {
        for (i, card) in aboutCardInfo.enumerated() {
            let subtitleView = SubtitleView.make(title: card.title, value: card.description)
            addArrangedSubview(subtitleView)
            
            let isLast = i == aboutCardInfo.count - 1
            if !isLast {
                addSeparator()
            }
        }
    }
    
    private func addSeparator() {
        let separator = SeparatorView.loadFromNib()
        addArrangedSubview(separator)
    }

}

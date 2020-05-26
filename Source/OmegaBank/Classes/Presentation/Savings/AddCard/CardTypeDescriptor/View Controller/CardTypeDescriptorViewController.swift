//
//  CardTypeDescriptorViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class CardTypeDescriptorViewController: StackedViewController {
    
    // MARK: - Public Properties
    
    var cardInfo: CardInfo? {
        willSet {
            showCardInfo(newValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func showCardInfo(_ cardInfo: CardInfo?) {
        clearArrangedSubviews()

        guard
            let cardInfo = cardInfo,
            let parameters = cardInfo.parameters else { return }

        for (i, card) in parameters.enumerated() {
            let subtitleView = SubtitleView.make(title: card.key, value: card.value)
            addArrangedSubview(subtitleView)

            let isLast = i == parameters.count - 1
            if !isLast {
                addSeparator()
            }
        }
    }
}

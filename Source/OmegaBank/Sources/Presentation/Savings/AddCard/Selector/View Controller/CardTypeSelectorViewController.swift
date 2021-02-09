//
//  CardTypeSelectorViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.CardInfo

final class CardTypeSelectorViewController: StackedViewController {
    
    // MARK: - Constants
    
    private let cardLabelOrigin = CGPoint(x: 14, y: 50)

    // MARK: - Public Properties
    
    override var axis: NSLayoutConstraint.Axis { .horizontal }
    
    override var animator: AppearingViewAnimator? { AppearingViewAnimator.makeRightToLeft(stackView: stackView) }
    
    var pager: ScrollViewPager?
    
    // MARK: - Private Properties
    
    private let cardTypes: [CardInfo]
    private var didAppearOnce = false
    
    // MARK: - Initialization

    init(cardTypes: [CardInfo]) {
        self.cardTypes = cardTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CardTypeSelectorViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillCardTypes()
        stackView.spacing = 20
        
        pager = ScrollViewPager(
            pageWidth: #imageLiteral(resourceName: "card").size.width,
            count: cardTypes.count,
            pageSpacing: stackView.spacing)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAppearOnce {
            animateAppearing()
            didAppearOnce = true
        }
    }

    // MARK: - Private Methods
    
    private func fillCardTypes() {
        for cardType in cardTypes {
            addCardType(cardType)
        }
    }
    
    private func addCardType(_ cardInfo: CardInfo) {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "card"))
        let containerView = UIView()
        containerView.accessibilityIdentifier = "card"
        containerView.addSubview(imageView, with: containerView)
        
        let typeLabel = UILabel()
        typeLabel.font = .body1
        typeLabel.textColor = .textPrimary
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.text = cardInfo.name
        typeLabel.accessibilityIdentifier = "name"
        
        containerView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: cardLabelOrigin.x),
            
            typeLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: cardLabelOrigin.y)])
        
        addArrangedSubview(containerView)
    }
}
//
//  PartnterDetailedViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/24/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

final class PartnterDetailedViewController: VerticalScrollableViewController {
    
    // MARK: - Types
    
    private enum Size {
        static let collectionViewTitleHeight: CGFloat = 21
        static let collectionViewHeight: CGFloat = 128
    }
    
    private enum Caption {
        static let limits = "LIMITS"
        static let dailyLimits = "DAILY LIMITS"
        static let pointType = "Point Type"
        static let limitations = "Limitations"
        static let description = "Description"
    }
    
    // MARK: - Private Properties
    
    private let partner: Partner
    
    // MARK: - Initialization
    
    init(partner: Partner) {
        self.partner = partner

        super.init(nibName: nil, bundle: nil)

        title = partner.name
        navigationItem.title = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PartnterDetailedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let limits = partner.limits.map { PartnerDescriptionViewModel(limit: $0) }
        let dailyLimits = partner.dailyLimits.map { PartnerDescriptionViewModel(limit: $0) }
        
        addCollectionViewItem(title: Caption.limits, viewModels: limits, accessibilityIdentifier: "limits")
        addSerapator()
        addCollectionViewItem(
            title: Caption.dailyLimits,
            viewModels: dailyLimits,
            accessibilityIdentifier: "dailyLimits")
        addSerapator()
        
        addDescriptionView(header: Caption.pointType, description: partner.pointType)
        addSerapator()
        addDescriptionView(header: Caption.description, description: partner.description)
        addSerapator()
        addDescriptionView(header: Caption.limitations, description: partner.limitations)
        addSerapator()

    }
    
    // MARK: - Private Methods
    
    private func addDescriptionView(header: String, description: String) {
        let limitationView = PartnerDescriptionView.make()
        let viewModel = PartnerDescriptionViewModel(header: header, description: description)
        limitationView.setup(with: viewModel)
        addArrangedSubview(limitationView)
    }
    
    private func addCollectionViewItem(
        title: String,
        viewModels: [PartnerDescriptionViewModel],
        accessibilityIdentifier: String) {
        
        let label = UILabel(frame: .zero)
        label.font = .caption1
        label.text = title
        label.textAlignment = .center
        addArrangedSubview(label)
        label.heightAnchor.constraint(equalToConstant: Size.collectionViewTitleHeight).isActive = true
        
        let collectionViewController = PartnerLimitCollectionViewController(viewModels: viewModels)
        addArrangedChild(collectionViewController)
        collectionViewController.view.heightAnchor.constraint(
            equalToConstant: Size.collectionViewHeight).isActive = true
        collectionViewController.collectionView.accessibilityIdentifier = accessibilityIdentifier
    }
    
    private func addSerapator() {
        let separator = PartnerSerapatorView(frame: .zero)
        addArrangedSubview(separator)
    }

}

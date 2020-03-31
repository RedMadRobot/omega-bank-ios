//
//  PartnterDetailedViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/24/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

final class PartnterDetailedViewController: UIViewController {
    
    // MARK: - Types
    
    private enum Size {
        static let collectionViewTitleHeight: CGFloat = 21
        static let collectionViewHeight: CGFloat = 128
        static let separatorViewHeight: CGFloat = 5
    }
    
    private enum Caption {
        static let limits = "LIMITS"
        static let dailyLimits = "DAILY LIMITS"
        static let pointType = "Point Type"
        static let limitations = "Limitations"
        static let description = "Description"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var parnterNameLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!
    
    // MARK: - Private Properties
    
    private let partner: Partner
    
    // MARK: - Initialization
    
    init(partner: Partner) {
        self.partner = partner

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PartnterDetailedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parnterNameLabel.text = partner.name
        
        // swiftlint:disable:next object_literal
        var image = UIImage(named: "chevron.left")
        
        if #available(iOS 13.0, *) {
            let symConf = UIImage.SymbolConfiguration(weight: .bold)
            image = UIImage(systemName: "chevron.left", withConfiguration: symConf)
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(pop))

        let limits = partner.limits.map { PartnerDescriptionViewModel(limit: $0) }
        let dailyLimits = partner.dailyLimits.map { PartnerDescriptionViewModel(limit: $0) }
        
        addCollectionViewItem(title: Caption.limits, viewModels: limits)
        addSerapator()
        addCollectionViewItem(title: Caption.dailyLimits, viewModels: dailyLimits)
        addSerapator()
        
        addDescriptionViewView(header: Caption.pointType, description: partner.pointType)
        addSerapator()
        addDescriptionViewView(header: Caption.description, description: partner.description)
        addSerapator()
        addDescriptionViewView(header: Caption.limitations, description: partner.limitations)
        addSerapator()
        
    }
    
    // MARK: - Private Methods
    
    @objc private func pop() {
        //navigationController?.popViewController(animated: true)
        
        navigationController?.dismiss(animated: true)
    }
    
    private func addDescriptionViewView(header: String, description: String) {
        let limitationView = PartnerDescriptionView.make()
        let viewModel = PartnerDescriptionViewModel(header: header, description: description)
        limitationView.setup(with: viewModel)

        stackView.addArrangedSubview(limitationView)
    }
    
    private func addCollectionViewItem(title: String, viewModels: [PartnerDescriptionViewModel]) {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.caption1
        label.text = title
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
        label.heightAnchor.constraint(equalToConstant: Size.collectionViewTitleHeight).isActive = true
        
        let collectionViewController = PartnerLimitCollectionViewController(viewModels: viewModels)
        addChild(collectionViewController)
        
        stackView.addArrangedSubview(collectionViewController.view)
        collectionViewController.view.heightAnchor.constraint(
            equalToConstant: Size.collectionViewHeight).isActive = true
        collectionViewController.didMove(toParent: self)
    }
    
    private func addSerapator() {
        let separator = PartnerSerapatorView(frame: CGRect.zero)
        stackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: Size.separatorViewHeight).isActive = true
    }
}

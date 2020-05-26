//
//  MainAddCardViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/29/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Card

protocol UserProductDelegate: AnyObject {
    func didTapNewProduct()
    func didShowNewProduct(_ product: Product)
}

final class MainAddCardViewController: ViewController {
    
    // MARK: - Types
    
    typealias CardParam = CardInfo.CardParam
    
    // MARK: - Private Properties
    
    private weak var delegate: UserProductDelegate?
    
    private var containerViewController: ScrollablePageViewController!
    private var selectorViewController: CardTypeSelectorViewController!
    private var descriptorViewController: CardTypeDescriptorViewController!

    private let cardTypes = [
        CardInfo(
            name: "classic",
            parameters: [
                CardParam(key: "INTRO PURCHASE APR", value: "N/A"),
                CardParam(key: "REGULAR PURCHASE APR", value: "15.99%-22.99% Variable"),
                CardParam(key: "INTRO BALANCE TRANSFER APR", value: "N/A"),
                CardParam(key: "ANNUAL FEE", value: "$0-$99")
        ]),
        CardInfo(
            name: "gold",
            parameters: [
                CardParam(key: "INTRO PURCHASE APR", value: "N/A"),
                CardParam(key: "REGULAR PURCHASE APR", value: "15.99%-22.99% Variable"),
                CardParam(key: "INTRO BALANCE TRANSFER APR", value: "N/A"),
                CardParam(key: "ANNUAL FEE", value: "$0-$199")
        ]),
        CardInfo(
            name: "platinum",
            parameters: [
                CardParam(key: "INTRO PURCHASE APR", value: "N/A"),
                CardParam(key: "REGULAR PURCHASE APR", value: "15.99%-22.99% Variable"),
                CardParam(key: "INTRO BALANCE TRANSFER APR", value: "N/A"),
                CardParam(key: "ANNUAL FEE", value: "$0-$299")
        ])
    ]
    
    // MARK: - Nested Properties
    
    override var hasDissmissedButton: Bool { true }
    
    // MARK: - Initialization
    
    static func make(delegate: UserProductDelegate?) -> UIViewController {
        let vc = MainAddCardViewController()
        vc.delegate = delegate
        
        return NavigationController(rootViewController: vc)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Card Applying"
        navigationItem.title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MainAddCardViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainerViewController()
        addSelectorViewController()
        addSeparator()
        addDescriptorViewController()
        addApplyButton()
    }
    
    private func addContainerViewController() {
        containerViewController = ScrollablePageViewController()
        containerViewController.title = title
        addChildViewController(containerViewController, to: view)
    }
    
    private func addSelectorViewController() {
        let horizontalContainerViewController = HorizonalScrollableViewController()
        containerViewController.addArrangedChild(horizontalContainerViewController)
        
        selectorViewController = CardTypeSelectorViewController(cardTypes: cardTypes)
        
        horizontalContainerViewController.delegate = self
        horizontalContainerViewController.addArrangedChild(selectorViewController)
        horizontalContainerViewController.pager = selectorViewController.pager
    }
    
    private func addSeparator() {
        containerViewController.addSeparator(with: .defaultBackground)
        containerViewController.addSeparator()
        containerViewController.addSeparator(with: .defaultBackground)
    }
    
    private func addDescriptorViewController() {
        descriptorViewController = CardTypeDescriptorViewController()
        containerViewController.addArrangedChild(descriptorViewController)
    }
    
    // MARK: - Private Methods
    
    private func addApplyButton() {
        let applyButton = UIButton()

        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = .buttonTitle
        applyButton.titleLabel?.textColor = .textPrimary
        applyButton.backgroundColor = .ph1
        applyButton.layer.cornerRadius = 3
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(applyNewCard), for: .touchUpInside)
        
        view.addSubview(applyButton)

        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            applyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func applyNewCard() {
        delegate?.didTapNewProduct()
        
        dismiss(animated: true) { [weak self] in
            let card = Card(name: "New deposit card", number: "NDSL RA01 203 4455 14", value: 77777)
            self?.delegate?.didShowNewProduct(card)
        }
    }
}

extension MainAddCardViewController: ScrollViewPagerDelegate {
    
    func didChangePage(page: Int) {
        let cardInfo = cardTypes[page]
        descriptorViewController.cardInfo = cardInfo
    }

}

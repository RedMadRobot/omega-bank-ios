//
//  MainAddCardViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/29/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Card
import struct OmegaBankAPI.CardInfo

protocol UserProductDelegate: AnyObject {
    func didTapNewProduct()
    func didShowNewProduct(_ product: Product)
}

final class MainAddCardViewController: ViewController, ErrorHandler {
    
    // MARK: - Constants
    
    private let applyButtonInsets = UIEdgeInsets(top: .zero, left: 20, bottom: -20, right: -20)
    
    // MARK: - Private Properties
    
    private weak var delegate: UserProductDelegate?
    
    private var containerViewController: ScrollablePageViewController!
    private var selectorViewController: CardTypeSelectorViewController!
    private var descriptorViewController: ProductTypeDescriptorViewController<CardInfo>!

    private var currentCardType: CardInfo?
    private var cardTypes: [CardInfo] = []
    private let cardListService: CardListService
    private var progress: Progress?
    
    // MARK: - Nested Properties
    
    override var hasDismissedButton: Bool { true }
    
    // MARK: - Initialization
    
    static func make(delegate: UserProductDelegate?) -> UIViewController {
        let vc = MainAddCardViewController()
        vc.delegate = delegate
        
        return NavigationController(rootViewController: vc)
    }

    init(cardListService: CardListService = ServiceLayer.shared.cardListService) {
        self.cardListService = cardListService
        
        super.init(nibName: nil, bundle: nil)

        title = "Card Applying"
        navigationItem.title = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progress?.cancel()
    }
    
    // MARK: - MainAddCardViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainerViewController()
        loadCardTypes()
    }
    
    // MARK: - Private Methods
    
    private func loadCardTypes() {
        progress = cardListService.loadTypes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cards):
                self.cardTypes = cards
                self.showCardTypes()
            case .failure(let error):
                self.showError(.error(error, onAction: { [weak self] in
                    self?.loadCardTypes()
                }))
            }
        }
    }
    
    private func showCardTypes() {
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
        descriptorViewController = ProductTypeDescriptorViewController<CardInfo>()
        containerViewController.addArrangedChild(descriptorViewController)
    }
    
    // MARK: - Private Methods
    
    private func addApplyButton() {
        let submitButton = SubmitButton()
        submitButton.setTitle("Apply", for: .normal)
        submitButton.onTap = { [unowned self] in
            self.applyNewCard()
        }
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: applyButtonInsets.bottom),
            submitButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: applyButtonInsets.left),
            submitButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: applyButtonInsets.right)
        ])
    }
    
    private func applyNewCard() {
        guard let cardType = currentCardType else { return }
        
        progress = cardListService.applyNewCard(with: cardType.code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let card):
                self.delegate?.didTapNewProduct()
                self.dismiss(animated: true) { [weak self] in
                    self?.delegate?.didShowNewProduct(card)
                }
            case .failure(let error):
                self.showError(.error(error, onAction: { [weak self] in
                    self?.applyNewCard()
                }))
            }
        }
    }
}

extension MainAddCardViewController: ScrollViewPagerDelegate {
    
    func didChangePage(page: Int) {
        let cardInfo = cardTypes[page]
        currentCardType = cardInfo
        descriptorViewController.productInfo = cardInfo
    }

}

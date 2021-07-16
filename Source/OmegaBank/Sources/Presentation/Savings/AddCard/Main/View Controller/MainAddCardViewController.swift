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
    func didChangeProductType()
}

extension UserProductDelegate {
    func didChangeProductType() { }
}

final class MainAddCardViewController: VerticalScrollableViewController {
    
    // MARK: - Constants
    
    private let applyButtonInsets = UIEdgeInsets(top: .zero, left: 20, bottom: -20, right: -20)
    
    // MARK: - Public Properties
    
    weak var delegate: UserProductDelegate?
    
    // MARK: - Private Properties

    private var selectorViewController: CardTypeSelectorViewController!
    private var descriptorViewController: ProductTypeDescriptorViewController<CardInfo>!

    private var currentCardType: CardInfo?
    private var cardTypes: [CardInfo] = []
    private let cardListService: CardListService
    private var progress: Progress?
    private var errorViewController: ErrorViewController?
    private var submitButton: SubmitButton?
    
    // MARK: - Initialization
    
    static func make(delegate: UserProductDelegate?) -> UIViewController {
        let vc = MainAddCardViewController()
        vc.delegate = delegate
        let ti = TitledPageViewController(
            title: "Card Applying",
            embeddedViewController: vc,
            hasDismissedButton: true)
        
        return NavigationController(rootViewController: ti)
    }

    init(cardListService: CardListService = ServiceLayer.shared.cardListService) {
        self.cardListService = cardListService
        
        super.init(nibName: nil, bundle: nil)
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
                self.showError(.error(error), onAction: { [unowned self] in
                    self.removeError()
                    self.loadCardTypes()
                })
            }
        }
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
                self.showError(.error(error), onAction: { [unowned self] in
                    self.removeError()
                    self.applyNewCard()
                })
            }
        }
    }
    
    private func showError(_ item: ErrorItem, onAction: VoidClosure?) {
        submitButton = nil
        let vc = ErrorViewController(item, onAction: onAction)
        addArrangedChild(vc)
        errorViewController = vc
    }
    
    private func removeError() {
        errorViewController?.removeFromParent()
        errorViewController = nil
    }

    private func showCardTypes() {
        addSelectorViewController()
        addSpecificSeparator()
        addDescriptorViewController()
        addApplyButton()
    }
    
    private func addSelectorViewController() {
        let horizontalContainerViewController = HorizontalScrollableViewController()
        addArrangedChild(horizontalContainerViewController)
        
        selectorViewController = CardTypeSelectorViewController(cardTypes: cardTypes)
        
        horizontalContainerViewController.delegate = self
        horizontalContainerViewController.addArrangedChild(selectorViewController)
        horizontalContainerViewController.pager = selectorViewController.pager
    }
    
    private func addSpecificSeparator() {
        addSeparator(with: .defaultBackground)
        addSeparator()
        addSeparator(with: .defaultBackground)
    }
    
    private func addDescriptorViewController() {
        descriptorViewController = ProductTypeDescriptorViewController<CardInfo>()
        addArrangedChild(descriptorViewController)
    }
    
    private func addApplyButton() {
        let button = SubmitButton()
        button.setTitle("Apply", for: .normal)
        button.accessibilityIdentifier = "apply"
        button.onTap = { [unowned self] in
            self.applyNewCard()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: applyButtonInsets.bottom),
            button.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: applyButtonInsets.left),
            button.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: applyButtonInsets.right)
        ])
        
        submitButton = button
    }
    
}

extension MainAddCardViewController: ScrollViewPagerDelegate {
    
    func didChangePage(page: Int) {
        let cardInfo = cardTypes[page]
        currentCardType = cardInfo
        descriptorViewController.productInfo = cardInfo
        delegate?.didChangeProductType()
    }

}

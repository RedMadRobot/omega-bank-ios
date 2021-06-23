//
//  MainAddDepositViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/29/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Deposit
import struct OmegaBankAPI.DepositInfo

final class MainAddDepositViewController: VerticalScrollableViewController {
    
    // MARK: - Constants
    
    private let applyButtonInsets = UIEdgeInsets(top: .zero, left: 20, bottom: -20, right: -20)
    
    // MARK: - Public Properties
    
    weak var delegate: UserProductDelegate?

    // MARK: - Private Properties
    
    private var selectorViewController: DepositTypeSelectorViewController!
    private var descriptorViewController: ProductTypeDescriptorViewController<DepositInfo>!

    private var currentDepositType: DepositInfo?
    private var depositTypes: [DepositInfo] = []
    private let listService: DepositListService
    private var progress: Progress?
    private var errorViewController: ErrorViewController?
    private var submitButton: SubmitButton?
    
    // MARK: - Initialization
    
    static func make(delegate: UserProductDelegate?) -> UIViewController {
        let vc = MainAddDepositViewController()
        vc.delegate = delegate
        
        let ti = TitledPageViewController(
            title: "Card Applying",
            embeddedViewController: vc,
            hasDismissedButton: true)

        return NavigationController(rootViewController: ti)
    }

    init(listService: DepositListService = ServiceLayer.shared.depositListService) {
        self.listService = listService
        
        super.init(nibName: nil, bundle: nil)

        title = "Deposit Applying"
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
        
        loadDepositTypes()
    }
    
    // MARK: - Private Methods
    
    private func loadDepositTypes() {
        progress = listService.loadTypes { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cards):
                self.depositTypes = cards
                self.showDepositTypes()
                
            case .failure(let error):
                self.showError(.error(error), onAction: { [unowned self] in
                    self.removeError()
                    self.loadDepositTypes()
                })
            }
        }
    }
    
    private func applyNewDeposit() {
        guard let depositType = currentDepositType else { return }
        
        progress = listService.applyNewDeposit(with: depositType.code) { [weak self] result in
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
                    self.applyNewDeposit()
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
    
    private func showDepositTypes() {
        addSelectorViewController()
        addSpecificSeparator()
        addDescriptorViewController()
        addApplyButton()
    }
    
    private func addSelectorViewController() {
        let horizontalContainerViewController = HorizonalScrollableViewController()
        addArrangedChild(horizontalContainerViewController)
        
        selectorViewController = DepositTypeSelectorViewController(depositTypes: depositTypes)
        
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
        descriptorViewController = ProductTypeDescriptorViewController<DepositInfo>()
        addArrangedChild(descriptorViewController)
    }
    
    private func addApplyButton() {
        let submitButton = SubmitButton()
        submitButton.setTitle("Apply", for: .normal)
        submitButton.accessibilityIdentifier = "apply"
        submitButton.onTap = { [unowned self] in
            self.applyNewDeposit()
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
}

extension MainAddDepositViewController: ScrollViewPagerDelegate {
    
    func didChangePage(page: Int) {
        let depositInfo = depositTypes[page]
        currentDepositType = depositInfo
        descriptorViewController.productInfo = depositInfo
        delegate?.didChangeProductType()
    }

}

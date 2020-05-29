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

final class MainAddDepositViewController: ViewController, ErrorHandler {
    
    // MARK: - Constants
    
    private let applyButtonInsets = UIEdgeInsets(top: .zero, left: 20, bottom: -20, right: -20)

    // MARK: - Private Properties
    
    private weak var delegate: UserProductDelegate?
    
    private var containerViewController: ScrollablePageViewController!
    private var selectorViewController: DepositTypeSelectorViewController!
    private var descriptorViewController: ProductTypeDescriptorViewController<DepositInfo>!

    private var currentDepositType: DepositInfo?
    private var depositTypes: [DepositInfo] = []
    private let listService: DepositListService
    private var progress: Progress?
    
    // MARK: - Nested Properties
    
    override var hasDismissedButton: Bool { true }
    
    // MARK: - Initialization
    
    static func make(delegate: UserProductDelegate?) -> UIViewController {
        let vc = MainAddDepositViewController()
        vc.delegate = delegate
        
        return NavigationController(rootViewController: vc)
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
        
        addContainerViewController()
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
                self.showError(.error(error, onAction: { [weak self] in
                    self?.loadDepositTypes()
                }))
            }
        }
    }
    
    private func showDepositTypes() {
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
        
        selectorViewController = DepositTypeSelectorViewController(depositTypes: depositTypes)
        
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
        descriptorViewController = ProductTypeDescriptorViewController<DepositInfo>()
        containerViewController.addArrangedChild(descriptorViewController)
    }
    
    // MARK: - Private Methods

    private func addApplyButton() {
        let submitButton = SubmitButton()
        submitButton.setTitle("Apply", for: .normal)
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
                self.showError(.error(error, onAction: { [weak self] in
                    self?.applyNewDeposit()
                }))
            }
        }
    }
}

extension MainAddDepositViewController: ScrollViewPagerDelegate {
    
    func didChangePage(page: Int) {
        let depositInfo = depositTypes[page]
        currentDepositType = depositInfo
        descriptorViewController.productInfo = depositInfo
    }

}

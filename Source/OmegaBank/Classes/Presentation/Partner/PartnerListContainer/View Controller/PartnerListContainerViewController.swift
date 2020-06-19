//
//  PartnerListContainerViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 6/14/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

final class PartnerListContainerViewController: PageViewController {
    
    // MARK: - Private Properties
    
    private let partnerListService: PartnerListService
    private var progress: Progress?
    private var errorViewController: ErrorViewController?
    
    // MARK: - Initializers
    
    static func make(delegate: ProfileViewControllerDelegate?) -> UIViewController {
        let controller = PartnerListContainerViewController()
        controller.delegate = delegate
        let navigationController = NavigationController(rootViewController: controller)

        return navigationController
    }
    
    init(partnerListService: PartnerListService = ServiceLayer.shared.partnerListService) {
        self.partnerListService = partnerListService
        
        super.init(title: "Partners", tabBarImage: #imageLiteral(resourceName: "customers"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        progress?.cancel()
    }
    
    // MARK: - PartnerListContainerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .defaultBackground
        loadPartners()
    }
    
    // MARK: - Private Methods
    
    private func loadPartners() {
        progress = partnerListService.load { [weak self] result in
            self?.loadDidFinish(result)
        }
    }
    
    private func loadDidFinish(_ result: Result<[Partner]>) {
        switch result {
        case .success(let list) where list.isEmpty:
            self.showError(.emptyPartners)
        case .success(let list):
            showPartner(list)
        case .failure(let error):
            self.showError(.error(error), onAction: { [unowned self] in
                self.removeError()
                self.loadPartners()
            })
        }
    }
    
    private func showPartner(_ list: [Partner]) {
        let vc = PartnerListViewController(partners: list)
        addChildViewController(vc, to: view)
    }
    
    private func showError(_ item: ErrorItem, onAction: (() -> Void)? = nil) {
        let vc = ErrorViewController(item, onAction: onAction)
        addChildViewController(vc, to: view)
        errorViewController = vc
    }
    
    private func removeError() {
        errorViewController?.removeChildFromParent()
        errorViewController = nil
    }
}

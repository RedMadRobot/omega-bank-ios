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
    
    // MARK: - Private Properties
    
    private weak var delegate: UserProductDelegate?
    
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
        
        let containerViewController = ScrollablePageViewController()
        containerViewController.title = title
        addChildViewController(containerViewController, to: view)
        
        let addCardViewController = AddCardViewController()
        containerViewController.addArrangedChild(addCardViewController)
        
        addApplyButton()
    }
    
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

//
//  ViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/13/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Nested Properties
    
    var hasDismissedButton: Bool { false }
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if hasDismissedButton { setupNavigationButtons() }
    }
    
    // MARK: - Private Methods
    
    @objc private func dismissView() {
        navigationController?.dismiss(animated: true)
    }
    
    private func setupNavigationButtons() {
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
            action: #selector(dismissView))
    }
}

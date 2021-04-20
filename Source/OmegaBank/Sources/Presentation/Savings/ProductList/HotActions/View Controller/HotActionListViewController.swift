//
//  HotActionListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class HotActionListViewController: StackedViewController {

    // MARK: - StackedViewController
    
    override var axis: NSLayoutConstraint.Axis { .horizontal }
    
    // MARK: - Private Properties
    
    private let actions = [
        "Action 1",
        "Action 2",
        "Action 3",
        "Action 4",
        "Action 5",
        "Action 6"]

    // MARK: - HotActionListViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButtons()
        
        stackView.spacing = 10
    }

    // MARK: - Private Methods
    
    private func addActionButtons() {
        for (i, title) in actions.enumerated() {
            addActionButton(title, in: i)
        }
    }
    
    private func addActionButton(_ title: String, in position: Int) {
        let view = HotActionView.make()
        view.setup(title: title, for: position)

        stackView.addArrangedSubview(view)
    }
    
}

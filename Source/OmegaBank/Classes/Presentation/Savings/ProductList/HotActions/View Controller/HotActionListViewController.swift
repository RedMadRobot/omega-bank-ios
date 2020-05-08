//
//  HotActionListViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/22/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class HotActionListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var stackView: UIStackView!
    
    // MARK: - Private Properties
    
    private let actions = ["Action 1",
                           "Action 2",
                           "Action 3",
                           "Action 4",
                           "Action 5",
                           "Action 6"]
    
    private var animator: AppearingViewAnimator?

    // MARK: - HotActionListViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if animator == nil {
            createAnimator()
            animateAppearing()
        }
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
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func createAnimator() {
        let animation = AppearingViewAnimator.makeMove(
            startOrigin: CGPoint(x: stackView.frame.width, y: 0),
            count: stackView.arrangedSubviews.count)

        animator = AppearingViewAnimator(animation: animation)
    }
    
    private func animateAppearing() {
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            animator?.animate(cell: view, index: i)
        }
    }
}

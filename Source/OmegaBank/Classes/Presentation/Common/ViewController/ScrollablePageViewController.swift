//
//  ScrollablePageViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol StackViewPresentable where Self: UIViewController {
    var stackView: UIStackView? { get }
}

extension StackViewPresentable {
    func addArrangedSubview(_ view: UIView) {
        stackView?.addArrangedSubview(view)
    }
    
    func addArrangedChild(_ child: UIViewController) {
        addChild(child)
        stackView?.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
}

final class ScrollablePageViewController: PageViewController, StackViewPresentable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sectionFooterHeight: CGFloat = 10
    }

    // MARK: - IBOutlets

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titledCurvedView: TitledCurvedView!
    @IBOutlet var stackView: UIStackView?

    // MARK: - ScrollablePageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titledCurvedView.setup(with: title ?? "")
    }
    
    // MARK: - Public Methods
    
    func addSeparator(with color: UIColor = .scrollViewBackground) {
        let view = UIView()
        
        view.backgroundColor = color
        addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: Constants.sectionFooterHeight).isActive = true
    }

}

//
//  ScrollablePageViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 4/7/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class ScrollablePageViewController: PageViewController {

    // MARK: - IBOutlets

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titledCurvedView: TitledCurvedView!
    @IBOutlet private var stackView: UIStackView!

    // MARK: - ScrollablePageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titledCurvedView.setup(with: title ?? "")
    }
    
    // MARK: - Public methods
    
    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    func addArrangedChild(_ child: UIViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }

}

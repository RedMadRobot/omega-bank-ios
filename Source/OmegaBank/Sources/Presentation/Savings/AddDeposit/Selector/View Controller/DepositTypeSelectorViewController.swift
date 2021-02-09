//
//  DepositTypeSelectorViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.DepositInfo

final class DepositTypeSelectorViewController: StackedViewController {
    
    // MARK: - Public Properties
    
    override var axis: NSLayoutConstraint.Axis { .horizontal }
    override var animator: AppearingViewAnimator? { AppearingViewAnimator.makeRightToLeft(stackView: stackView) }

    var pager: ScrollViewPager?
    
    // MARK: - Private Properties
    
    private let depositTypes: [DepositInfo]
    private var didAppearOnce = false
    
    // MARK: - Initialization

    init(depositTypes: [DepositInfo]) {
        self.depositTypes = depositTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - DepositTypeSelectorViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDepositTypes()
        stackView.spacing = 20
        
        pager = ScrollViewPager(
            pageWidth: DepositTypeView.size.width,
            count: depositTypes.count,
            pageSpacing: stackView.spacing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAppearOnce {
            animateAppearing()
            didAppearOnce = true
        }
    }

    // MARK: - Private Methods
    
    private func fillDepositTypes() {
        for (i, type) in depositTypes.enumerated() {
            let view = DepositTypeView.make(depositInfo: type, index: i)

            addArrangedSubview(view)
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: DepositTypeView.size.width),
                view.heightAnchor.constraint(equalToConstant: DepositTypeView.size.height)])
        }
    }
    
}

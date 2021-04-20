//
//  StackedViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// ViewController со StackView в корне
class StackedViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var axis: NSLayoutConstraint.Axis { .vertical }
    var isCollapsed: Bool = false {
        didSet {
            guard isCollapsed != oldValue else { return }
            stackView.arrangedSubviews.forEach { $0.isHidden.toggle() }
        }
    }
    let stackView = UIStackView()

    // MARK: - StackedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStackView()
    }
    
    // MARK: - Public Methods
    
    func addSeparator(isAnimated: Bool = true) {
        let separator = SeparatorView.loadFromNib()

        stackView.addArrangedSubview(separator)
    }
    
    func addArrangedChild(_ child: UIViewController) {
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func insertArrangedSubview(_ view: UIView, at: Int) {
        stackView.insertArrangedSubview(view, at: at)
    }
    
    func clearArrangedSubviews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Private Methods
    
    private func addStackView() {
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = axis
        
        view.addSubview(stackView, with: view)
    }

}

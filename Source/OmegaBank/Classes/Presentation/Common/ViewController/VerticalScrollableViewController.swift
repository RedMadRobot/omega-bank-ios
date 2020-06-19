//
//  VerticalScrollableViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 6/6/20.
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

class VerticalScrollableViewController: ViewController, StackViewPresentable {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sectionFooterHeight: CGFloat = 10
    }
    
    // MARK: - StackViewPresentable

    var stackView: UIStackView?
    
    // MARK: - Private Properties
    
    var scrollView: UIScrollView!
    
    // MARK: - VerticalScrollableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScrollView()
        addStackView()
    }
    
    private func addScrollView() {
        let scroll = UIScrollView()
        view.addSubview(scroll, with: view)
        scrollView = scroll
    }
    
    private func addStackView() {
        let stack = UIStackView()
        stack.axis = .vertical
        scrollView.addSubview(stack, with: scrollView)
        scrollView.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive = true
        stackView = stack
    }
    
    // MARK: - Public Methods
    
    func addSeparator(with color: UIColor = .scrollViewBackground) {
        let view = UIView()
        
        view.backgroundColor = color
        addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: Constants.sectionFooterHeight).isActive = true
    }

}

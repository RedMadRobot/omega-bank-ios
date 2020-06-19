//
//  StackedViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// ViewController со StackView в корне. С высыпающейся анимацией при начальной загрузке.
class StackedViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var axis: NSLayoutConstraint.Axis { .vertical }
    var isCollapsed: Bool = false {
        didSet {
            guard isCollapsed != oldValue else { return }
            animate()
        }
    }
    let stackView = UIStackView()
    var animator: AppearingViewAnimator? { .downToUp }

    // MARK: - StackedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStackView()
    }
    
    // MARK: - Public Methods
    
    func addSeparator(isAnimated: Bool = true) {
        let separator = SeparatorView.loadFromNib()
        addArrangedSubview(separator, isAnimated: isAnimated)
    }
    
    /// Если элемент добавляется с анимацией то сначала нам нужно выставить
    /// начальное состояние элемента, для этого и введен параметр `isAnimated`
    func addArrangedSubview(_ view: UIView, isAnimated: Bool = true) {
        if isAnimated { animator?.setInitialState(view: view) }
        stackView.addArrangedSubview(view)
    }
    
    func addArrangedChild(_ child: UIViewController) {
        animator?.setInitialState(view: view)
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func insertArrangedSubview(_ view: UIView, at: Int) {
        animator?.setInitialState(view: view)
        stackView.insertArrangedSubview(view, at: at)
    }
    
    func clearArrangedSubviews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func animateAppearing() {
        setStartPositionForAnimation()
        animate()
    }

    // MARK: - Private Methods
    
    private func addStackView() {
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = axis
        
        view.addSubview(stackView, with: view)
    }
    
    // MARK: - Animation
    
    private func setStartPositionForAnimation() {
        for view in stackView.arrangedSubviews {
            animator?.setStartState(view: view)
        }
    }
    
    private func animate() {
        guard isViewLoaded else { return }
        
        let count = stackView.arrangedSubviews.count
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            animator?.animate(
                view: view,
                isCollapsed: isCollapsed,
                index: i,
                count: count)
        }
    }

}

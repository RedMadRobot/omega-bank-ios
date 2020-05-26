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
    
    var isCollapsed = false {
        willSet {
            if isCollapsed != newValue {
                animateToggle()
            }
        }
    }
    
    var toggleAnimator: AppearingViewAnimator?
    let stackView = UIStackView()
    
    // MARK: - Private Properties
    
    private var didAppearOnce = false
    private var animator: AppearingViewAnimator?

    // MARK: - StackedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAppearOnce {
            createAnimator()
            createToggleAnimator()
            
            animateAppearing()
            didAppearOnce = true
        }
    }
    
    // MARK: - Public Methods
    
    func addSeparator() {
        let separator = SeparatorView.loadFromNib()
        separator.alpha = didAppearOnce ? 1 : 0
        addArrangedSubview(separator)
    }
    
    /// Эвент, показывающий переключение состояния isCollapsed
    func didToggle() { }
    
    private func setAlpha(_ view: UIView) {
        // Альфу выставим в 1 после, в анимации
        // или же сразу в 1 если анимация уже была
        view.alpha = didAppearOnce ? 1 : 0
    }
    
    func addArrangedSubview(_ view: UIView) {
        setAlpha(view)
        stackView.addArrangedSubview(view)
    }
    
    func addArrangedChild(_ child: UIViewController) {
        setAlpha(child.view)
        addChild(child)
        stackView.addArrangedSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func insertArrangedSubview(_ view: UIView, at: Int) {
        view.alpha = 0 // Альфу выставим в 1 после, в анимации
        view.isHidden = true
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
    
    // MARK: - Animation
    
    private func createAnimator() {
        let animationType = AppearingViewAnimator.animationType(axis: axis)
        let animation = animationType.animation(count: stackView.arrangedSubviews.count, size: stackView.frame.size)
        animator = AppearingViewAnimator(animation: animation)
    }
    
    private func createToggleAnimator() {
        let animation = AppearingViewAnimator.makeHide(count: stackView.arrangedSubviews.count)
        toggleAnimator = AppearingViewAnimator(animation: animation)
    }
    
    private func animateAppearing() {
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            animator?.animate(cell: view, index: i)
        }
    }
    
    private func animateToggle() {
        didToggle()
        for (i, view) in stackView.arrangedSubviews.enumerated().dropFirst() {
            toggleAnimator?.animate(cell: view, index: i)
        }
    }
    
}

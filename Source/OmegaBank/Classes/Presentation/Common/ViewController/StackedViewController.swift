//
//  StackedViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/3/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// ViewController со StackView в корне. С распахивающейся анимацией при начальной загрузке.
class StackedViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var arrangedSubviewCount: Int { stackView.arrangedSubviews.count }
    
    var isCollapsed = false {
        willSet {
            if isCollapsed != newValue {
                animateToggle()
            }
        }
    }
    
    var toggleAnimator: AppearingViewAnimator!
    
    // MARK: - Private Properties
    
    private var stackView = UIStackView()
    private var animator: AppearingViewAnimator?

    // MARK: - StackedViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if animator == nil {
            createAnimator()
            animateAppearing()
        }
        
        if toggleAnimator == nil {
            createToggleAnimator()
        }
    }
    
    // MARK: - Public Methods
    
    /// Эвент, показывающий переключение состояния isCollapsed
    func didToggle() { }
    
    func addArrangedSubview(_ view: UIView) {
        view.alpha = 0 // Альфу выставим в 1 после, в анимации
        stackView.addArrangedSubview(view)
    }
    
    func insertArrangedSubview(_ view: UIView, at: Int) {
        view.alpha = 0 // Альфу выставим в 1 после, в анимации
        view.isHidden = true
        stackView.insertArrangedSubview(view, at: at)
    }
    
    // MARK: - Private Methods
    
    private func addStackView() {
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        view.addSubview(stackView, with: view)
    }
    
    // MARK: - Animation
    
    private func createAnimator() {
        let animation = AppearingViewAnimator.makeMove(
            startOrigin: CGPoint(x: 0, y: stackView.frame.height),
            count: arrangedSubviewCount)
        animator = AppearingViewAnimator(animation: animation)
    }
    
    private func createToggleAnimator() {
        let animation = AppearingViewAnimator.makeHide(count: arrangedSubviewCount)
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
            toggleAnimator.animate(cell: view, index: i)
        }
    }

}

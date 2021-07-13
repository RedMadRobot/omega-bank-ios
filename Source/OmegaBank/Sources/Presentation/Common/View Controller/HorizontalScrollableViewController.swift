//
//  HorizontalScrollableViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/21/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class HorizontalScrollableViewController: UIViewController {

    // MARK: - IBOutlets
    
    var stackView: UIStackView?
    private var scrollView: UIScrollView!
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    weak var delegate: ScrollViewPagerDelegate?
    weak var pager: ScrollViewPager?

    // MARK: - Private Properties
    
    private var horizontalInset: CGFloat = 15 {
        willSet {
            leadingConstraint.constant = newValue
            trailingConstraint.constant = newValue
        }
    }
    
    private var didAppearOnce = false
    
    // MARK: - HorizontalScrollableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addScrollView()
        addStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if pager != nil && !didAppearOnce {
            addPager()
            didAppearOnce = true
        }
    }
    
    // MARK: - Private Methods
    
    private func addScrollView() {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        view.addSubview(scroll, with: view)
        scrollView = scroll
    }
    
    private func addStackView() {
        let stack = UIStackView()
        stack.axis = .vertical
        let leading = scrollView.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: horizontalInset)
        let trailing = stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: horizontalInset)

        scrollView.addSubview(stack, activate: [
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            leading,
            trailing,
            stack.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        leadingConstraint = leading
        trailingConstraint = trailing

        stackView = stack
    }

    private func addPager() {
        guard let pager = pager else { return }
        
        scrollView.delegate = self

        let leftInset = (scrollView.frame.width - pager.pageWidth) / 2
        horizontalInset = leftInset

        pager.delegate = delegate
        
        if pager.isEmpty { delegate?.didChangePage(page: pager.page) }
    }

}

extension HorizontalScrollableViewController: StackViewPresentable {}

extension HorizontalScrollableViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        pager?.scrollViewWillEndDragging(
            scrollView,
            with: velocity,
            targetContentOffset: targetContentOffset)
    
    }

}

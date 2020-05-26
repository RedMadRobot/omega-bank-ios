//
//  HorizonalScrollableViewController.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/21/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class HorizonalScrollableViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet var stackView: UIStackView?
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var leadingConstraint: NSLayoutConstraint!
    @IBOutlet private var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    
    weak var delegate: ScrollViewPagerDelegate?
    weak var pager: ScrollViewPager?
    
    var horizontalInset: CGFloat = 15 {
        willSet {
            leadingConstraint.constant = newValue
            trailingConstraint.constant = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private var didAppearOnce = false
    
    // MARK: - HorizonalScrollableViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if pager != nil && !didAppearOnce {
            addPager()
            didAppearOnce = true
        }
    }
    
    // MARK: - Private Methods
    
    private func addPager() {
        guard let pager = pager else { return }
        
        scrollView.delegate = self

        let leftInset = (scrollView.frame.width - pager.pageWidth) / 2
        horizontalInset = leftInset

        pager.delegate = delegate
        
        if pager.isEmpty { delegate?.didChangePage(page: pager.page) }
    }

}

extension HorizonalScrollableViewController: StackViewPresentable {}

extension HorizonalScrollableViewController: UIScrollViewDelegate {
    
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

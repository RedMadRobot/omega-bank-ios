//
//  ScrollViewPager.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 5/20/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol ScrollViewPagerDelegate: AnyObject {
    func didChangePage(page: Int)
}

final class ScrollViewPager {

    // MARK: - Public Properties
    
    let pageWidth: CGFloat
    let pageSpacing: CGFloat

    private(set) var page = 0 {
        willSet {
            delegate?.didChangePage(page: newValue)
        }
    }
    
    // В `ScrollViewPager` нет коллекции поэтому мы
    // не можем заменить `count > 0` на `isEmpty()`
    // swiftlint:disable:next empty_count
    var isEmpty: Bool { count > 0 }
    
    weak var delegate: ScrollViewPagerDelegate?
    
    // MARK: - Private Properties
    
    private let count: Int
    
    // MARK: - Initialization
    
    init(
        pageWidth: CGFloat,
        count: Int,
        pageSpacing: CGFloat = 0) {
        
        self.pageWidth = pageWidth
        self.count = count
        self.pageSpacing = pageSpacing
    }
    
    // MARK: - Public Methods

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        with velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
            switchCurrentPageIfNeeded(with: velocity)

            let x = CGFloat(page) * (pageWidth + pageSpacing)
            let offset = CGPoint(x: x, y: .zero)
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    targetContentOffset.pointee = offset
                    scrollView.contentOffset = offset
                })
    }
    
    // MARK: - Private Method
    
    private func switchCurrentPageIfNeeded(with velocity: CGPoint) {
        
        switch velocity.x {
        case let x where x < 0 && page > 0:
            page -= 1
        case let x where x > 0.5 && page < count - 1:
            page += 1
        default:
            break
        }
        
    }
    
}

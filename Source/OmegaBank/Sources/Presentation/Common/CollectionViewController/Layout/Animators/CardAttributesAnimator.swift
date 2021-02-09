//
//  OrthogonalCardAttributesAnimator.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 20.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class CardAttributesAnimator: LayoutAttributesAnimator {

    var minAlpha: CGFloat
    var itemSpacing: CGFloat
    var scaleRate: CGFloat

    init(minAlpha: CGFloat = 0.5, itemSpacing: CGFloat = 0.4, scaleRate: CGFloat = 0.7) {
        self.minAlpha = minAlpha
        self.itemSpacing = itemSpacing
        self.scaleRate = scaleRate
    }

    func animate(
        collectionView: UICollectionView,
        attributes: UICollectionViewLayoutAttributes,
        scrollDirection: UICollectionView.ScrollDirection) {
        
        let distance: CGFloat
        let itemOffset: CGFloat

        switch scrollDirection {
        case .horizontal:
            distance = collectionView.frame.width
            itemOffset = attributes.center.x - collectionView.contentOffset.x
        case .vertical:
            distance = collectionView.frame.height
            itemOffset = attributes.center.y - collectionView.contentOffset.y
        default:
            return
        }

        let middleOffset = itemOffset / distance - 0.5
        let scaleFactor = scaleRate - 0.1 * abs(middleOffset)
        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translationTransform: CGAffineTransform

        switch scrollDirection {
        case .horizontal:
            let translationX = -(collectionView.frame.width * itemSpacing * middleOffset)
            translationTransform = CGAffineTransform(translationX: translationX, y: 0)
        case .vertical:
            let translationY = -(collectionView.frame.height * itemSpacing * middleOffset)
            translationTransform = CGAffineTransform(translationX: 0, y: translationY)
        default:
            fatalError("Неподдерживаемое направление скрола")
        }

        attributes.alpha = 1.0 - abs(middleOffset) + minAlpha
        attributes.transform = translationTransform.concatenating(scaleTransform)
    }
}

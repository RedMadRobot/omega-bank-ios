//
//  AnimatedOrthogonalLayout.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 20.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

final class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {

    /// Аниматор, обрабатывающий переходы.
    var animator: LayoutAttributesAnimator?

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes
            .compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
            .map { transformLayoutAttributes($0) }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // при скролинге пересчитываем лайаут
        true
    }

    private func transformLayoutAttributes(
        _ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let collectionView = collectionView else { return attributes }

        animator?.animate(
            collectionView: collectionView,
            attributes: attributes,
            scrollDirection: scrollDirection)

        return attributes
    }
}

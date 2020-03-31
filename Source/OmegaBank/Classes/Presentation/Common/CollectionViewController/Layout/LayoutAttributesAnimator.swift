//
//  LayoutAttributesAnimator.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 20.03.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

protocol LayoutAttributesAnimator {
    func animate(
        collectionView: UICollectionView,
        attributes: UICollectionViewLayoutAttributes,
        scrollDirection: UICollectionView.ScrollDirection)
}

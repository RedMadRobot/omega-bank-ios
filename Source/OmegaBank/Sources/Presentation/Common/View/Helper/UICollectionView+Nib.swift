//
//  UICollectionView+Nib.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

typealias NibCollectionViewCell = UICollectionViewCell & NibRepresentable

extension UICollectionView {

    func registerCellNib<T>(_ cellType: T.Type) where T: NibCollectionViewCell {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.className)
    }

    func dequeueReusableCell<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: NibCollectionViewCell {
        let anyCell = dequeueReusableCell(withReuseIdentifier: cellType.className, for: indexPath)

        guard let cell = anyCell as? T else {
            fatalError("Unexpected cell type \(anyCell)")
        }

        return cell
    }
}

//
//  UITableView+Nib.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

typealias NibTableViewCell = UITableViewCell & NibRepresentable

extension UITableView {

    func registerCellNib<T>(_ cellType: T.Type) where T: NibTableViewCell {
        register(cellType.nib, forCellReuseIdentifier: cellType.className)
    }

    func dequeueReusableCell<T>(_ cellType: T.Type, for indexPath: IndexPath) -> T where T: NibTableViewCell {
        let anyCell = dequeueReusableCell(withIdentifier: cellType.className, for: indexPath)

        guard let cell = anyCell as? T else {
            fatalError("Unexpected cell type \(anyCell)")
        }
        return cell
    }
}

typealias NibTableHeaderView = UITableViewHeaderFooterView & NibLoadable

extension UITableView {

    func registerHeaderNib<T>(_ headerType: T.Type) where T: NibTableHeaderView {
        register(headerType.nib, forHeaderFooterViewReuseIdentifier: headerType.className)
    }

    func dequeueReusableHeaderFooterView<T>(_ headerType: T.Type) -> NibTableHeaderView? where T: NibTableHeaderView {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: headerType.className) else {
            return nil
        }
        guard let header = view as? T else {
            fatalError("Unexpected header type \(view)")
        }
        return header
    }
}

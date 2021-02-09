//
//  TableViewCell.swift
//  OmegaBank
//
//  Created by Nikolai Zhukov on 25.02.2020.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        disableDefaultChangeBackgroundColorSubviews {
            super.setHighlighted(highlighted, animated: animated)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        disableDefaultChangeBackgroundColorSubviews {
            super.setSelected(selected, animated: animated)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let bgColorView = UIView()
        bgColorView.backgroundColor = .backgroundPrimaryPressed
        selectedBackgroundView = bgColorView
    }

    // MARK: - Private

    private func disableDefaultChangeBackgroundColorSubviews(_ block: () -> Void) {
        // по умолчанию при выделении ячейки у `subviews` пропадает цвет фона
        var subviewsBackgroundColor: [UIView: UIColor] = [:]

        func saveBackgroundColor(for view: UIView) {
            subviewsBackgroundColor[view] = view.backgroundColor
            view.subviews.forEach(saveBackgroundColor)
        }
        saveBackgroundColor(for: contentView)

        block()

        subviewsBackgroundColor.forEach { $0.backgroundColor = $1 }
    }
}

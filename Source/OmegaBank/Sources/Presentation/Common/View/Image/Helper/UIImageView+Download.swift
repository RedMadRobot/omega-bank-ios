//
//  UIImageView+Download.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import AlamofireImage
import UIKit

extension UIImageView {

    /// Установить картинку по URL.
    ///
    /// - Parameters:
    ///   - url: Адрес по которому нужно загрузить картинку.
    ///   - placeholder: Временая картинка пока грузится основная.
    func setImage(at url: URL, placeholder: UIImage?) {
        af_setImage(withURL: url, placeholderImage: placeholder)
    }
}

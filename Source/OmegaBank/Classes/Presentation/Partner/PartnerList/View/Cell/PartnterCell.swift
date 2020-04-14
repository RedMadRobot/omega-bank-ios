//
//  PartnterCell.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/23/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit
import struct OmegaBankAPI.Partner

final class PartnterCell: UICollectionViewCell, NibRepresentable {
    
    // MARK: - Outlets
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var limitationsTextView: UITextView!
    @IBOutlet private var shadowView: ShadowView!
    
    // MARK: - Public Methods
    
    func setup(with partner: Partner, for index: Int) {
        do {
            // Посколько с бека приходит текст с элементами HTML нам нужно добавить допольнительное форматирование.
            if let htmlAttributed = try """
                \(partner.pointType)<br><br>
                \(partner.description)<br><br>
                \(partner.limitations)
                """.makeHtmlAttributed() {
                htmlAttributed.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textPrimary,
                                              NSAttributedString.Key.font: UIFont.body1],
                                              range: NSRange(location: 0, length: htmlAttributed.length))
                
                limitationsTextView.attributedText = htmlAttributed
            }
        } catch {
            print("error")
        }

        nameLabel.text = partner.name
        
        if let picture = partner.picture {
            imageView.setImage(at: picture, placeholder: nil)
        }
        
        shadowView.backgroundColor = UIColor.palette[index % UIColor.palette.count]
    }
}

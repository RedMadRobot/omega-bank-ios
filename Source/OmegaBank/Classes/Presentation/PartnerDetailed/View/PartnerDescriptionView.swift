//
//  PartnerDescriptionView.swift
//  OmegaBank
//
//  Created by Nikolay Zhukov on 3/26/20.
//  Copyright © 2020 RedMadRobot. All rights reserved.
//

import UIKit

/// View для отображение длинных текстовых полей.

final class PartnerDescriptionView: UIView, NibLoadable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textView: UITextView!
    
    // MARK: - Initializers
    
    static func make() -> PartnerDescriptionView {
        PartnerDescriptionView.loadFromNib()
    }
    
    // MARK: - Public Methods
    
    func setup(with viewModel: PartnerDescriptionViewModel) {
        titleLabel.text = viewModel.header
        
        do {
            // Посколько с бека приходит текст с элементами HTML нам нужно добавить допольнительное форматирование.
            if let attrString = try viewModel.description.makeHtmlAttributed() {
                attrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.textSupplementary,
                                          NSAttributedString.Key.font: UIFont.body2],
                                         range: NSRange(location: 0, length: attrString.length))
                
                textView.attributedText = attrString
            }
        } catch {
            print("error")
        }
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.sizeToFit()
        textView.isScrollEnabled = false
    }
    
}

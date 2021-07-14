//
//  AtmMarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

/// View банкоматов
final class AtmMarkerAnnotationView: BankPointMarkerAnnotationView {
    
    // MARK: - Public methods
    
    func setup(_ annotation: MapAnnotation) {
        setupBankPointMarkerAnnotationView()
        glyphText = "ω"
        
        detailLabel.text = annotation.subtitle
    }
}

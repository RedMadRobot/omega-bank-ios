//
//  MarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 06.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

/// View офисов
final class OfficeMarkerAnnotationView: BankPointMarkerAnnotationView {

    // MARK: - Public methods
    
    func setup(_ annotation: MapAnnotation) {
        setupBankPointMarkerAnnotationView()
        glyphText = "Ω"
        
        detailLabel.text = annotation.subtitle
    }
}

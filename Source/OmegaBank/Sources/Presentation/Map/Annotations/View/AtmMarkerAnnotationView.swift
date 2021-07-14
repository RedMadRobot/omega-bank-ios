//
//  AtmMarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

/// View банкоматов
final class AtmMarkerAnnotationView: BankPointMarkerAnnotationView {
    
    // MARK: - Public methods
    
    override func setup(_ annotation: MKAnnotation) {
        super.setup(annotation)
        
        glyphText = "ω"
        markerTintColor = .curve1
    }
    
}

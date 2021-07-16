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
    
    override func setup(_ annotation: MKAnnotation) {
        super.setup(annotation)
        
        markerTintColor = .curve2
        glyphText = "Ω"
    }
}

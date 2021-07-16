//
//  ClusterMarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

final class ClusterMarkerAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - Public methods
    
    func setup(_ annotation: MKClusterAnnotation) {
        glyphText = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
        
        glyphTintColor = .textPrimary
        markerTintColor = .curve2
        titleVisibility = .hidden
        subtitleVisibility = .hidden
        canShowCallout = false
    }
    
}

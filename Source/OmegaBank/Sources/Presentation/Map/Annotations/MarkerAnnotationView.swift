//
//  MarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 06.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

final class MarkerAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - Private properties
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.body2
        return label
    }()
    
    // MARK: - Init
    
    required override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let annotation = annotation as? MapAnnotation {
            setup(annotation)
        } else {
            setup()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private func setup(_ annotation: MapAnnotation) {
        
        canShowCallout = true
        glyphImage = Asset.omega.image
        glyphTintColor = .textPrimary
        markerTintColor = .curve2
        titleVisibility = .hidden
        detailLabel.text = annotation.subtitle
        detailCalloutAccessoryView = detailLabel
    }
    
    private func setup() {
        
        canShowCallout = true
        glyphImage = Asset.omega.image
        glyphTintColor = .textPrimary
        markerTintColor = .curve2
        titleVisibility = .hidden
        detailLabel.text = "test\ntest\ntest"
        detailCalloutAccessoryView = detailLabel
    }
}

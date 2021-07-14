//
//  MarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 06.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

final class MarkerAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let mapButtonFrame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
    }
    
    // MARK: - Private properties
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .body2
        return label
    }()
    private let mapsButton: UIButton = {
        let button = UIButton(frame: Constants.mapButtonFrame)
        button.setBackgroundImage(Asset.maps.image, for: .normal)
        return button
    }()
    
    // MARK: - Public methods
    
    func setupMapAnnotation(_ annotation: MapAnnotation) {
        glyphText = "Ω"
        
        glyphTintColor = .textPrimary
        markerTintColor = .curve2
        titleVisibility = .hidden
        canShowCallout = true
        
        detailLabel.text = annotation.subtitle
        detailCalloutAccessoryView = detailLabel
        rightCalloutAccessoryView = mapsButton
    }
    
    func setupClusterAnnotation(_ annotation: MKClusterAnnotation) {
        glyphText = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
        
        glyphTintColor = .textPrimary
        markerTintColor = .curve2
        titleVisibility = .hidden
        subtitleVisibility = .hidden
        canShowCallout = false
        
    }
}

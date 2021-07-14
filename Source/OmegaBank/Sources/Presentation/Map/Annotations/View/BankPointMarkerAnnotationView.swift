//
//  PointMarkerAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

/// Базовая view банковской точки
class BankPointMarkerAnnotationView: MKMarkerAnnotationView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let mapButtonFrame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
    }
    
    // MARK: - Public properties
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .body2
        return label
    }()
    
    // MARK: - Private properties
    
    private let mapsButton: UIButton = {
        let button = UIButton(frame: Constants.mapButtonFrame)
        button.setBackgroundImage(Asset.maps.image, for: .normal)
        return button
    }()
    
    // MARK: - Public methods
    
    func setupBankPointMarkerAnnotationView() {
        glyphTintColor = .textPrimary
        titleVisibility = .hidden
        canShowCallout = true
        
        detailCalloutAccessoryView = detailLabel
        rightCalloutAccessoryView = mapsButton
    }
    
}

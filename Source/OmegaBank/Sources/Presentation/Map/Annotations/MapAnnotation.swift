//
//  AtmMapAnnotation.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 14.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

import struct OmegaBankAPI.BankPlace

enum AnnotationType {
    case atm
    case office
}

final class MapAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Public properties
    
    let type: AnnotationType
    
    let coordinate: CLLocationCoordinate2D
    
    let title: String?
    
    let subtitle: String?
    
    // MARK: - Init
    
    init(type: AnnotationType, latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        self.type = type
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
}

extension BankPlace {
    func makeAnnotation(_ type: AnnotationType) -> MKAnnotation {
        MapAnnotation(
            type: type,
            latitude: location.latitude,
            longitude: location.longitude,
            title: name, subtitle: address)
    }
}

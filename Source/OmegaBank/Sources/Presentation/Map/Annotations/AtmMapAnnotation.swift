//
//  AtmMapAnnotation.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 14.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import Foundation

import MapKit
import struct OmegaBankAPI.Atm

final class AtmMapAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    let title: String?
    
    let subtitle: String?
    
    // MARK: - Init
    
    init(latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
}

extension Atm {
    var annotation: MKAnnotation {
        AtmMapAnnotation(
            latitude: location.latitude,
            longitude: location.longitude,
            title: name,
            subtitle: address)
    }
}

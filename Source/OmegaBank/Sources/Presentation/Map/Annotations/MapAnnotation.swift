//
//  MapAnnotation.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 01.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit
import struct OmegaBankAPI.Office

final class MapAnnotation: NSObject, MKAnnotation {
    
    static let identifier = String(describing: self)
    
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

extension Office {

    var annotation: MapAnnotation {
        MapAnnotation(
            latitude: location.latitude,
            longitude: location.longitude,
            title: name,
            subtitle: address)
    }
    
}

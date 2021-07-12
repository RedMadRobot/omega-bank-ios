//
//  GoogleMapsScheme.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 07.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

struct GoogleMapsScheme: MapAppScheme {
    
    private enum Constants {
        static let pointParameter = "q"
        static let locationParameter = "center"
        static let scaleParameter = "zoom"
        static let mapModeParameter = "mapmode"
        
        static let pointValue = ""
        static let scaleValue = "14"
        static let mapModeValue = "standard"
    }
    
    let label = "Google Maps"
    let scheme = "comgooglemaps"
    var annotation: MKAnnotation
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = ""
        components.queryItems = [
            URLQueryItem(name: Constants.pointParameter, value: Constants.pointValue),
            URLQueryItem(
                name: Constants.locationParameter,
                value: "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"),
            URLQueryItem(name: Constants.scaleParameter, value: Constants.scaleValue),
            URLQueryItem(name: Constants.mapModeParameter, value: Constants.mapModeValue)
        ]
        return components.url
    }
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
    
}

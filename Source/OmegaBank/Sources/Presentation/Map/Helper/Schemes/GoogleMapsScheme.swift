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
    
    let label: String = "Google Maps"
    let scheme: URL? = URL(string: "comgooglemaps://")
    var annotation: MKAnnotation
    
    var url: URL? {
        let stringScheme = scheme?.absoluteString
        
        let request = URLRequest(url: URL(string: stringScheme!)!)
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let pointQueryItem = URLQueryItem(name: Constants.pointParameter, value: Constants.pointValue)
        let coordinateQueryItem = URLQueryItem(
            name: Constants.locationParameter,
            value: "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)")
        let scaleQueryItem = URLQueryItem(name: Constants.scaleParameter, value: Constants.scaleValue)
        let mapModeQueryItem = URLQueryItem(name: Constants.mapModeParameter, value: Constants.mapModeValue)
        components?.queryItems = [pointQueryItem, coordinateQueryItem, scaleQueryItem, mapModeQueryItem]
        
        return components?.url
    }
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
    
}

//
//  YandexMapsScheme.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 07.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

struct YandexMapsScheme: MapAppScheme {
    
    private enum Constants {
        static let pointParameter = "pt"
        static let scaleParameter = "z"
        static let mapTypeParameter = "l"
        
        static let scaleValue = "15"
        static let mapTypeValue = "map"
    }
    
    let label = "Yandex Maps"
    let scheme = "yandexmaps"
    var annotation: MKAnnotation
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = ""
        components.queryItems = [
            URLQueryItem(
                name: Constants.pointParameter,
                value: String(describing: "\(annotation.coordinate.longitude),\(annotation.coordinate.latitude)")),
            URLQueryItem(name: Constants.scaleParameter, value: Constants.scaleValue),
            URLQueryItem(name: Constants.mapTypeParameter, value: Constants.mapTypeValue)
        ]
        return components.url
    }
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
}

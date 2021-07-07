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
    
    let label: String = "Yandex Maps"
    let scheme: URL? = URL(string: "yandexmaps://")
    var annotation: MKAnnotation
    
    var url: URL? {
        let stringScheme = scheme?.absoluteString
        
        let request = URLRequest(url: URL(string: stringScheme!)!)
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        let coordinateQueryItem = URLQueryItem(
            name: Constants.pointParameter,
            value: String(describing: "\(annotation.coordinate.longitude),\(annotation.coordinate.latitude)"))
        let scaleQueryItem = URLQueryItem(name: Constants.scaleParameter, value: Constants.scaleValue)
        let mapTypeQueryItem = URLQueryItem(name: Constants.mapTypeParameter, value: Constants.mapTypeValue)
        components?.queryItems = [coordinateQueryItem, scaleQueryItem, mapTypeQueryItem]
        
        return components?.url
    }
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
    }
    
}

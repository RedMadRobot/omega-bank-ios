//
//  AppSchemeRouter.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 07.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

final class AppSchemeRouter {
    
    private let mapSchemes: [MapAppScheme]
    private let annotation: MKAnnotation
    
    /// Проверка доступных приложений для открытий их в картах
    lazy private(set) var availableMapApps: [String: URL] = {
        var availableSchemes: [String: URL] = [:]
        for scheme in mapSchemes {
            guard
                let url = URL(string: "\(scheme.scheme)" + "://"),
                UIApplication.shared.canOpenURL(url),
                let availableUrl = scheme.url
            else {
                continue
            }
            availableSchemes[scheme.label] = availableUrl
        }
        
        return availableSchemes
    }()
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        mapSchemes = [
            GoogleMapsScheme(annotation: annotation),
            YandexMapsScheme(annotation: annotation)
        ]
    }
}

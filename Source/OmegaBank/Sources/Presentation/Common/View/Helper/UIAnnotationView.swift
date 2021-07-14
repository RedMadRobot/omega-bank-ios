//
//  UIAnnotationView.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 09.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

extension MapViewController {

    func registerAnnotationViewNib<T>(mapView: MKMapView, _ viewType: T.Type) where T: MKAnnotationView {
        mapView.register(viewType, forAnnotationViewWithReuseIdentifier: String(describing: viewType.self))
    }

    func dequeueReusableView<T>(
        mapView: MKMapView,
        _ viewType: T.Type,
        for annotation: MKAnnotation) -> T where T: MKAnnotationView {
        
        let anyView = mapView.dequeueReusableAnnotationView(
            withIdentifier: String(describing: viewType.self),
            for: annotation)

        guard let view = anyView as? T else {
            fatalError("Unexpected cell type \(anyView)")
        }

        return view
    }
}

//
//  UIAnnotationView+Nib.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 09.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit
import UIKit

typealias NibAnnotationView = MKAnnotationView & NibRepresentable

extension MapViewController {

    func registerAnnotationViewNib<T>(mapView: MKMapView, _ viewType: T.Type) where T: NibAnnotationView {
        mapView.register(viewType, forAnnotationViewWithReuseIdentifier: viewType.className)
    }

    func dequeueReusableView<T>(
        mapView: MKMapView,
        _ viewType: T.Type,
        for annotation: MKAnnotation) -> T where T: NibAnnotationView {
        
        let anyView = mapView.dequeueReusableAnnotationView(withIdentifier: viewType.className, for: annotation)

        guard let view = anyView as? T else {
            fatalError("Unexpected cell type \(anyView)")
        }

        return view
    }
}
